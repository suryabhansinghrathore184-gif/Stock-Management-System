using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class products : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDropdowns();
                BindGrid();
            }
        }

        private void BindDropdowns()
        {
            try
            {
                // Categories Dropdown
                DataSet dsCat = dc.GetDataSet("SELECT CategoryId, CategoryName FROM Categories WHERE Status = 'Active' ORDER BY CategoryName ASC");
                
                DdlCategory.DataSource = dsCat;
                DdlCategory.DataTextField = "CategoryName";
                DdlCategory.DataValueField = "CategoryId";
                DdlCategory.DataBind();
                DdlCategory.Items.Insert(0, new ListItem("-- Select Category --", ""));

                // Filter Categories Dropdown
                DdlFilterCategory.DataSource = dsCat;
                DdlFilterCategory.DataTextField = "CategoryName";
                DdlFilterCategory.DataValueField = "CategoryId";
                DdlFilterCategory.DataBind();
                DdlFilterCategory.Items.Insert(0, new ListItem("All Categories", ""));

                // Suppliers Dropdown
                DataSet dsSupp = dc.GetDataSet("SELECT supplierid, suppliername FROM NewSupplier WHERE supplierstatus = 'Active' ORDER BY suppliername ASC");
                DdlSupplier.DataSource = dsSupp;
                DdlSupplier.DataTextField = "suppliername";
                DdlSupplier.DataValueField = "supplierid";
                DdlSupplier.DataBind();
                DdlSupplier.Items.Insert(0, new ListItem("-- Select Supplier --", ""));
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading dropdowns: " + ex.Message);
            }
        }

        private void BindGrid(string search = "", string categoryFilter = "")
        {
            try
            {
                string query = @"SELECT p.ProductCode, p.ProductName, p.PurchasePrice, p.SellingPrice, p.Quantity, p.ProductImage, p.Barcode, p.Description,
                                       c.CategoryName, s.suppliername
                                FROM Products p
                                INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                                INNER JOIN NewSupplier s ON p.SupplierId = s.supplierid
                                WHERE 1=1";

                int paramCount = 0;
                if (!string.IsNullOrEmpty(search)) paramCount++;
                if (!string.IsNullOrEmpty(categoryFilter)) paramCount++;

                SqlParameter[] parameters = paramCount > 0 ? new SqlParameter[paramCount] : null;
                int paramIndex = 0;

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (p.ProductCode LIKE @Search OR p.ProductName LIKE @Search)";
                    parameters[paramIndex++] = new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" };
                }

                if (!string.IsNullOrEmpty(categoryFilter))
                {
                    query += " AND p.CategoryId = @CategoryId";
                    parameters[paramIndex++] = new SqlParameter("@CategoryId", SqlDbType.Int) { Value = Convert.ToInt32(categoryFilter) };
                }

                query += " ORDER BY p.ProductName ASC";
                DataSet ds = dc.GetDataSet(query, parameters);
                GridProducts.DataSource = ds;
                GridProducts.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading products: " + ex.Message);
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string productCode = TxtProductCode.Text.Trim();
            string productName = TxtProductName.Text.Trim();
            string categoryId = DdlCategory.SelectedValue;
            string supplierId = DdlSupplier.SelectedValue;
            decimal purchasePrice = 0;
            decimal sellingPrice = 0;
            int quantity = 0;
            string barcode = TxtBarcode.Text.Trim();
            string description = TxtDescription.Text.Trim();
            bool isEdit = Convert.ToBoolean(EditModeHidden.Value);

            // Parsing numeric fields
            decimal.TryParse(TxtPurchasePrice.Text, out purchasePrice);
            decimal.TryParse(TxtSellingPrice.Text, out sellingPrice);
            int.TryParse(TxtQuantity.Text, out quantity);

            try
            {
                // Verify unique product code for new products
                if (!isEdit)
                {
                    string checkQuery = "SELECT COUNT(*) FROM Products WHERE ProductCode = @ProductCode";
                    SqlParameter[] checkParams = new SqlParameter[]
                    {
                        new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode }
                    };
                    int count = Convert.ToInt32(dc.ExecuteScalar(checkQuery, checkParams));
                    if (count > 0)
                    {
                        ShowAlert("Product Code already exists. Please choose a unique code.");
                        return;
                    }
                }

                // Handle file upload
                string fileName = CurrentImagePath.Value;
                if (FileProductImage.HasFile)
                {
                    string ext = Path.GetExtension(FileProductImage.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif")
                    {
                        // Ensure Links folder exists
                        string folderPath = Server.MapPath("~/Links/");
                        if (!Directory.Exists(folderPath))
                        {
                            Directory.CreateDirectory(folderPath);
                        }

                        // Delete old image if exists
                        if (isEdit && !string.IsNullOrEmpty(CurrentImagePath.Value))
                        {
                            string oldFilePath = Path.Combine(folderPath, CurrentImagePath.Value);
                            if (File.Exists(oldFilePath))
                            {
                                File.Delete(oldFilePath);
                            }
                        }

                        // Generate unique file name to avoid overwrite conflicts
                        fileName = Guid.NewGuid().ToString() + ext;
                        FileProductImage.SaveAs(Path.Combine(folderPath, fileName));
                    }
                    else
                    {
                        ShowAlert("Only image files (.jpg, .jpeg, .png, .gif) are allowed.");
                        return;
                    }
                }

                if (isEdit)
                {
                    // Update Product
                    string updateQuery = @"UPDATE Products 
                                          SET ProductName = @ProductName, CategoryId = @CategoryId, SupplierId = @SupplierId,
                                              PurchasePrice = @PurchasePrice, SellingPrice = @SellingPrice, Quantity = @Quantity,
                                              Barcode = @Barcode, Description = @Description, ProductImage = @ProductImage
                                          WHERE ProductCode = @ProductCode";

                    SqlParameter[] updateParams = new SqlParameter[]
                    {
                        new SqlParameter("@ProductName", SqlDbType.VarChar) { Value = productName },
                        new SqlParameter("@CategoryId", SqlDbType.Int) { Value = Convert.ToInt32(categoryId) },
                        new SqlParameter("@SupplierId", SqlDbType.VarChar) { Value = supplierId },
                        new SqlParameter("@PurchasePrice", SqlDbType.Decimal) { Value = purchasePrice },
                        new SqlParameter("@SellingPrice", SqlDbType.Decimal) { Value = sellingPrice },
                        new SqlParameter("@Quantity", SqlDbType.Int) { Value = quantity },
                        new SqlParameter("@Barcode", SqlDbType.VarChar) { Value = string.IsNullOrEmpty(barcode) ? (object)DBNull.Value : barcode },
                        new SqlParameter("@Description", SqlDbType.VarChar) { Value = string.IsNullOrEmpty(description) ? (object)DBNull.Value : description },
                        new SqlParameter("@ProductImage", SqlDbType.VarChar) { Value = string.IsNullOrEmpty(fileName) ? (object)DBNull.Value : fileName },
                        new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode }
                    };

                    dc.ExecuteNonQuery(updateQuery, updateParams);
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Updated!', 'Product updated successfully.', 'success');", true);
                }
                else
                {
                    // Insert Product
                    string insertQuery = @"INSERT INTO Products (ProductCode, ProductName, CategoryId, SupplierId, PurchasePrice, SellingPrice, Quantity, Barcode, Description, ProductImage)
                                          VALUES (@ProductCode, @ProductName, @CategoryId, @SupplierId, @PurchasePrice, @SellingPrice, @Quantity, @Barcode, @Description, @ProductImage)";

                    SqlParameter[] insertParams = new SqlParameter[]
                    {
                        new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode },
                        new SqlParameter("@ProductName", SqlDbType.VarChar) { Value = productName },
                        new SqlParameter("@CategoryId", SqlDbType.Int) { Value = Convert.ToInt32(categoryId) },
                        new SqlParameter("@SupplierId", SqlDbType.VarChar) { Value = supplierId },
                        new SqlParameter("@PurchasePrice", SqlDbType.Decimal) { Value = purchasePrice },
                        new SqlParameter("@SellingPrice", SqlDbType.Decimal) { Value = sellingPrice },
                        new SqlParameter("@Quantity", SqlDbType.Int) { Value = quantity },
                        new SqlParameter("@Barcode", SqlDbType.VarChar) { Value = string.IsNullOrEmpty(barcode) ? (object)DBNull.Value : barcode },
                        new SqlParameter("@Description", SqlDbType.VarChar) { Value = string.IsNullOrEmpty(description) ? (object)DBNull.Value : description },
                        new SqlParameter("@ProductImage", SqlDbType.VarChar) { Value = string.IsNullOrEmpty(fileName) ? (object)DBNull.Value : fileName }
                    };

                    dc.ExecuteNonQuery(insertQuery, insertParams);

                    // Insert StockHistory record
                    string historyQuery = "INSERT INTO StockHistory (ProductCode, ChangeType, Quantity, Remarks) VALUES (@ProductCode, 'Adjustment', @Quantity, 'Initial product creation')";
                    SqlParameter[] histParams = new SqlParameter[]
                    {
                        new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode },
                        new SqlParameter("@Quantity", SqlDbType.Int) { Value = quantity }
                    };
                    dc.ExecuteNonQuery(historyQuery, histParams);

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Saved!', 'Product created successfully.', 'success');", true);
                }

                ResetForm();
                BindGrid(TxtSearch.Text.Trim(), DdlFilterCategory.SelectedValue);
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving product: " + ex.Message);
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        protected void BtnRemoveImage_Click(object sender, EventArgs e)
        {
            CurrentImagePath.Value = "";
            ImgPreview.ImageUrl = "";
            ImgPreview.CssClass = "product-preview d-none";
            BtnRemoveImage.Visible = false;
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            BindGrid(TxtSearch.Text.Trim(), DdlFilterCategory.SelectedValue);
        }

        protected void DdlFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindGrid(TxtSearch.Text.Trim(), DdlFilterCategory.SelectedValue);
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            TxtSearch.Text = "";
            DdlFilterCategory.SelectedIndex = 0;
            BindGrid();
        }

        protected void GridProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridProducts.PageIndex = e.NewPageIndex;
            BindGrid(TxtSearch.Text.Trim(), DdlFilterCategory.SelectedValue);
        }

        protected void GridProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditProduct")
            {
                LoadProductForEdit(e.CommandArgument.ToString());
            }
            else if (e.CommandName == "DeleteProduct")
            {
                DeleteProduct(e.CommandArgument.ToString());
            }
        }

        protected void GridProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Handled in RowCommand
        }

        private void LoadProductForEdit(string code)
        {
            try
            {
                string query = "SELECT * FROM Products WHERE ProductCode = @ProductCode";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = code }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    TxtProductCode.Text = row["ProductCode"].ToString();
                    TxtProductCode.Enabled = false; // Disable editing code
                    TxtProductName.Text = row["ProductName"].ToString();
                    DdlCategory.SelectedValue = row["CategoryId"].ToString();
                    DdlSupplier.SelectedValue = row["SupplierId"].ToString();
                    TxtPurchasePrice.Text = row["PurchasePrice"].ToString();
                    TxtSellingPrice.Text = row["SellingPrice"].ToString();
                    TxtQuantity.Text = row["Quantity"].ToString();
                    TxtQuantity.Enabled = false; // Quantity managed by sales/purchases/adjustments
                    TxtBarcode.Text = row["Barcode"].ToString();
                    TxtDescription.Text = row["Description"].ToString();

                    string imgFile = row["ProductImage"].ToString();
                    CurrentImagePath.Value = imgFile;
                    if (!string.IsNullOrEmpty(imgFile))
                    {
                        ImgPreview.ImageUrl = "/Links/" + imgFile;
                        ImgPreview.CssClass = "product-preview";
                        BtnRemoveImage.Visible = true;
                    }
                    else
                    {
                        ImgPreview.CssClass = "product-preview d-none";
                        BtnRemoveImage.Visible = false;
                    }

                    FormTitleLabel.Text = "Edit Product";
                    BtnSave.Text = "Update Product";
                    EditModeHidden.Value = "true";
                    BtnCancel.Visible = true;
                    AlertPanel.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading product: " + ex.Message);
            }
        }

        private void DeleteProduct(string code)
        {
            try
            {
                // Delete physical image file
                string queryImg = "SELECT ProductImage FROM Products WHERE ProductCode = @ProductCode";
                SqlParameter[] imgParams = new SqlParameter[]
                {
                    new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = code }
                };
                string imgFile = dc.ExecuteScalar(queryImg, imgParams) as string;

                if (!string.IsNullOrEmpty(imgFile))
                {
                    string filePath = Path.Combine(Server.MapPath("~/Links/"), imgFile);
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                // Delete from DB (foreign keys cascade or restrict, we used ON DELETE NO ACTION in schema.sql for transactions, so delete might throw if purchased/sold)
                // Let's verify if product has transaction history
                string checkHistQuery = @"SELECT 
                                            (SELECT COUNT(*) FROM Purchases WHERE ProductCode = @ProductCode) + 
                                            (SELECT COUNT(*) FROM Sales WHERE ProductCode = @ProductCode)";
                SqlParameter[] checkParams = new SqlParameter[]
                {
                    new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = code }
                };
                int linkedTransactions = Convert.ToInt32(dc.ExecuteScalar(checkHistQuery, checkParams));
                if (linkedTransactions > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Cannot Delete!', 'This product has active sales or purchase history and cannot be deleted.', 'error');", true);
                    return;
                }

                string deleteQuery = "DELETE FROM Products WHERE ProductCode = @ProductCode";
                SqlParameter[] deleteParams = new SqlParameter[]
                {
                    new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = code }
                };
                dc.ExecuteNonQuery(deleteQuery, deleteParams);

                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Deleted!', 'Product deleted successfully.', 'success');", true);
                BindGrid(TxtSearch.Text.Trim(), DdlFilterCategory.SelectedValue);
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting product: " + ex.Message);
            }
        }

        private void ResetForm()
        {
            TxtProductCode.Text = "";
            TxtProductCode.Enabled = true;
            TxtProductName.Text = "";
            DdlCategory.SelectedIndex = 0;
            DdlSupplier.SelectedIndex = 0;
            TxtPurchasePrice.Text = "";
            TxtSellingPrice.Text = "";
            TxtQuantity.Text = "";
            TxtQuantity.Enabled = true;
            TxtBarcode.Text = "";
            TxtDescription.Text = "";
            CurrentImagePath.Value = "";
            ImgPreview.ImageUrl = "";
            ImgPreview.CssClass = "product-preview d-none";
            BtnRemoveImage.Visible = false;

            FormTitleLabel.Text = "Add New Product";
            BtnSave.Text = "Save Product";
            EditModeHidden.Value = "false";
            BtnCancel.Visible = false;
            AlertPanel.Visible = false;
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }
    }
}
