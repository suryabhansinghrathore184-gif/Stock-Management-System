using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class s_products : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["sid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCategories();
                LoadProducts();
            }
        }

        private void LoadCategories()
        {
            try
            {
                string query = "SELECT CategoryId, CategoryName FROM Categories WHERE Status = 'Active' ORDER BY CategoryName";
                DdlCategory.DataSource = dc.GetDataSet(query).Tables[0];
                DdlCategory.DataTextField = "CategoryName";
                DdlCategory.DataValueField = "CategoryId";
                DdlCategory.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading categories: " + ex.Message);
            }
        }

        private void LoadProducts()
        {
            string sid = Session["sid"].ToString();
            try
            {
                string query = "SELECT ProductCode, ProductName, SellingPrice, Quantity, ProductImage FROM Products WHERE SupplierId = @SupplierId ORDER BY ProductName";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                GvProducts.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvProducts.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading products: " + ex.Message);
            }
        }

        protected void BtnSaveProduct_Click(object sender, EventArgs e)
        {
            string sid = Session["sid"].ToString();
            string code = TxtCode.Text.Trim();
            string name = TxtName.Text.Trim();
            int catId = Convert.ToInt32(DdlCategory.SelectedValue);
            decimal purchasePrice = 0;
            decimal sellingPrice = 0;
            int qty = 0;
            string barcode = TxtBarcode.Text.Trim();
            string desc = TxtDesc.Text.Trim();
            string imageFilename = "";

            decimal.TryParse(TxtPurchasePrice.Text, out purchasePrice);
            decimal.TryParse(TxtSellingPrice.Text, out sellingPrice);
            int.TryParse(TxtQty.Text, out qty);

            if (string.IsNullOrEmpty(code) || string.IsNullOrEmpty(name) || purchasePrice <= 0 || sellingPrice <= 0)
            {
                ShowAlert("Product Code, Name, Purchase Price, and Selling Price are required and must be positive numbers.");
                return;
            }

            try
            {
                // File Upload
                if (FuImage.HasFile)
                {
                    string ext = Path.GetExtension(FuImage.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
                    {
                        ShowAlert("Only image files (.jpg, .png, .webp) are allowed.");
                        return;
                    }

                    if (FuImage.PostedFile.ContentLength > 5242880) // 5MB limit
                    {
                        ShowAlert("Image file size must be under 5MB.");
                        return;
                    }

                    string dir = Server.MapPath("~/Links/");
                    if (!Directory.Exists(dir))
                    {
                        Directory.CreateDirectory(dir);
                    }

                    imageFilename = code + "_prod_" + Path.GetFileName(FuImage.FileName);
                    FuImage.SaveAs(Path.Combine(dir, imageFilename));
                }

                // Check Edit State vs Add State by checking if TxtCode is readonly
                if (TxtCode.ReadOnly)
                {
                    // Update
                    string update = @"UPDATE Products 
                                     SET ProductName = @Name, CategoryId = @Cat, PurchasePrice = @Purchase, 
                                         SellingPrice = @Selling, Quantity = @Qty, Barcode = @Barcode, Description = @Desc,
                                         ProductImage = CASE WHEN @Photo <> '' THEN @Photo ELSE ProductImage END
                                     WHERE ProductCode = @Code";
                    SqlParameter[] param = new SqlParameter[]
                    {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Cat", catId),
                        new SqlParameter("@Purchase", purchasePrice),
                        new SqlParameter("@Selling", sellingPrice),
                        new SqlParameter("@Qty", qty),
                        new SqlParameter("@Barcode", barcode),
                        new SqlParameter("@Desc", desc),
                        new SqlParameter("@Photo", imageFilename),
                        new SqlParameter("@Code", code)
                    };
                    dc.ExecuteNonQuery(update, param);
                    ShowAlert("Product updated successfully!");
                }
                else
                {
                    // Verify uniqueness of code
                    string check = "SELECT COUNT(*) FROM Products WHERE ProductCode = @Code";
                    if (Convert.ToInt32(dc.ExecuteScalar(check, new SqlParameter[] { new SqlParameter("@Code", code) })) > 0)
                    {
                        ShowAlert("A product with this Product Code already exists.");
                        return;
                    }

                    // Insert
                    string insert = @"INSERT INTO Products (ProductCode, ProductName, CategoryId, SupplierId, PurchasePrice, SellingPrice, Quantity, Barcode, Description, ProductImage) 
                                     VALUES (@Code, @Name, @Cat, @SupplierId, @Purchase, @Selling, @Qty, @Barcode, @Desc, @Photo)";
                    SqlParameter[] param = new SqlParameter[]
                    {
                        new SqlParameter("@Code", code),
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Cat", catId),
                        new SqlParameter("@SupplierId", sid),
                        new SqlParameter("@Purchase", purchasePrice),
                        new SqlParameter("@Selling", sellingPrice),
                        new SqlParameter("@Qty", qty),
                        new SqlParameter("@Barcode", barcode),
                        new SqlParameter("@Desc", desc),
                        new SqlParameter("@Photo", imageFilename)
                    };
                    dc.ExecuteNonQuery(insert, param);
                    ShowAlert("Product added successfully!");
                }

                ResetForm();
                LoadProducts();
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving product: " + ex.Message);
            }
        }

        protected void GvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string code = e.CommandArgument.ToString();

            if (e.CommandName == "EditProduct")
            {
                try
                {
                    string query = "SELECT * FROM Products WHERE ProductCode = @Code";
                    SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Code", code) };
                    DataSet ds = dc.GetDataSet(query, param);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataRow row = ds.Tables[0].Rows[0];
                        TxtCode.Text = row["ProductCode"].ToString();
                        TxtCode.ReadOnly = true;
                        TxtName.Text = row["ProductName"].ToString();
                        DdlCategory.SelectedValue = row["CategoryId"].ToString();
                        TxtPurchasePrice.Text = Convert.ToDecimal(row["PurchasePrice"]).ToString("N2");
                        TxtSellingPrice.Text = Convert.ToDecimal(row["SellingPrice"]).ToString("N2");
                        TxtQty.Text = row["Quantity"].ToString();
                        TxtBarcode.Text = row["Barcode"].ToString();
                        TxtDesc.Text = row["Description"].ToString();

                        LblFormTitle.Text = "Edit Product Details";
                        BtnCancel.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading details: " + ex.Message);
                }
            }
            else if (e.CommandName == "DeleteProduct")
            {
                try
                {
                    // Check if sold before deleting (foreign key constraints check)
                    string checkSales = "SELECT COUNT(*) FROM Sales WHERE ProductCode = @Code";
                    int soldCount = Convert.ToInt32(dc.ExecuteScalar(checkSales, new SqlParameter[] { new SqlParameter("@Code", code) }));
                    if (soldCount > 0)
                    {
                        ShowAlert("Cannot delete this product because it has active sales transactions in history. You can set stock quantity to 0 instead.");
                        return;
                    }

                    string checkPurchases = "SELECT COUNT(*) FROM Purchases WHERE ProductCode = @Code";
                    int purchCount = Convert.ToInt32(dc.ExecuteScalar(checkPurchases, new SqlParameter[] { new SqlParameter("@Code", code) }));
                    if (purchCount > 0)
                    {
                        ShowAlert("Cannot delete this product because it has active supply logs in history.");
                        return;
                    }

                    string query = "DELETE FROM Products WHERE ProductCode = @Code";
                    dc.ExecuteNonQuery(query, new SqlParameter[] { new SqlParameter("@Code", code) });
                    ShowAlert("Product deleted successfully.");
                    LoadProducts();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error deleting product: " + ex.Message);
                }
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            TxtCode.Text = "";
            TxtCode.ReadOnly = false;
            TxtName.Text = "";
            TxtPurchasePrice.Text = "";
            TxtSellingPrice.Text = "";
            TxtQty.Text = "0";
            TxtBarcode.Text = "";
            TxtDesc.Text = "";

            LblFormTitle.Text = "Add New Product";
            BtnCancel.Visible = false;
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}
