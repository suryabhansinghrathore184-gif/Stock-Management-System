using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class WebForm7 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                TxtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                BindDropdowns();
                BindGrid();
            }
        }

        private void BindDropdowns()
        {
            try
            {
                // Suppliers Dropdown
                DataSet dsSupp = dc.GetDataSet("SELECT supplierid, suppliername FROM NewSupplier WHERE supplierstatus = 'Active' ORDER BY suppliername ASC");
                DdlSupplier.DataSource = dsSupp;
                DdlSupplier.DataTextField = "suppliername";
                DdlSupplier.DataValueField = "supplierid";
                DdlSupplier.DataBind();
                DdlSupplier.Items.Insert(0, new ListItem("-- Select Supplier --", ""));

                // Products Dropdown
                DataSet dsProd = dc.GetDataSet("SELECT ProductCode, ProductName FROM Products ORDER BY ProductName ASC");
                DdlProduct.DataSource = dsProd;
                DdlProduct.DataTextField = "ProductName";
                DdlProduct.DataValueField = "ProductCode";
                DdlProduct.DataBind();
                DdlProduct.Items.Insert(0, new ListItem("-- Select Product --", ""));
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading dropdowns: " + ex.Message);
            }
        }

        protected void DdlProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            string productCode = DdlProduct.SelectedValue;
            if (!string.IsNullOrEmpty(productCode))
            {
                try
                {
                    string query = "SELECT PurchasePrice FROM Products WHERE ProductCode = @ProductCode";
                    SqlParameter[] param = new SqlParameter[]
                    {
                        new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode }
                    };
                    object price = dc.ExecuteScalar(query, param);
                    if (price != null)
                    {
                        TxtPrice.Text = Convert.ToDecimal(price).ToString("0.00");
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading product price: " + ex.Message);
                }
            }
            else
            {
                TxtPrice.Text = "";
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string supplierId = DdlSupplier.SelectedValue;
            string productCode = DdlProduct.SelectedValue;
            decimal price = 0;
            int quantity = 0;
            DateTime purchaseDate;

            decimal.TryParse(TxtPrice.Text, out price);
            int.TryParse(TxtQuantity.Text, out quantity);
            if (!DateTime.TryParse(TxtDate.Text, out purchaseDate))
            {
                purchaseDate = DateTime.Now;
            }

            if (string.IsNullOrEmpty(supplierId) || string.IsNullOrEmpty(productCode) || price <= 0 || quantity <= 0)
            {
                ShowAlert("Please enter valid purchase details.");
                return;
            }

            try
            {
                // Create transactional commands list
                List<SqlCommand> commandList = new List<SqlCommand>();

                // 1. Insert Purchase Record
                SqlCommand cmdPurchase = new SqlCommand(@"INSERT INTO Purchases (SupplierId, ProductCode, Quantity, PurchasePrice, PurchaseDate)
                                                          VALUES (@SupplierId, @ProductCode, @Quantity, @PurchasePrice, @PurchaseDate)");
                cmdPurchase.Parameters.AddWithValue("@SupplierId", supplierId);
                cmdPurchase.Parameters.AddWithValue("@ProductCode", productCode);
                cmdPurchase.Parameters.AddWithValue("@Quantity", quantity);
                cmdPurchase.Parameters.AddWithValue("@PurchasePrice", price);
                cmdPurchase.Parameters.AddWithValue("@PurchaseDate", purchaseDate);
                commandList.Add(cmdPurchase);

                // 2. Increase Stock Quantity in Products Table
                SqlCommand cmdUpdateStock = new SqlCommand(@"UPDATE Products SET Quantity = Quantity + @Quantity WHERE ProductCode = @ProductCode");
                cmdUpdateStock.Parameters.AddWithValue("@Quantity", quantity);
                cmdUpdateStock.Parameters.AddWithValue("@ProductCode", productCode);
                commandList.Add(cmdUpdateStock);

                // 3. Log into StockHistory for Auditing
                SqlCommand cmdHistory = new SqlCommand(@"INSERT INTO StockHistory (ProductCode, ChangeType, Quantity, Remarks)
                                                         VALUES (@ProductCode, 'Purchase', @Quantity, @Remarks)");
                cmdHistory.Parameters.AddWithValue("@ProductCode", productCode);
                cmdHistory.Parameters.AddWithValue("@Quantity", quantity);
                cmdHistory.Parameters.AddWithValue("@Remarks", "Purchased from supplier: " + DdlSupplier.SelectedItem.Text);
                commandList.Add(cmdHistory);

                // Execute Transaction
                bool success = dc.ExecuteTransaction(commandList);
                if (success)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Success!', 'Purchase registered and stock increased.', 'success');", true);
                    ResetForm();
                    BindGrid();
                }
                else
                {
                    ShowAlert("Failed to complete purchase transaction.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error recording purchase: " + ex.Message);
            }
        }

        private void BindGrid(string search = "")
        {
            try
            {
                string query = @"SELECT p.PurchaseId, p.Quantity, p.PurchasePrice, p.PurchaseDate,
                                       s.suppliername, prod.ProductName
                                FROM Purchases p
                                INNER JOIN NewSupplier s ON p.SupplierId = s.supplierid
                                INNER JOIN Products prod ON p.ProductCode = prod.ProductCode";

                SqlParameter[] parameters = null;
                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE s.suppliername LIKE @Search OR prod.ProductName LIKE @Search";
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" }
                    };
                }

                query += " ORDER BY p.PurchaseDate DESC, p.PurchaseId DESC";
                DataSet ds = dc.GetDataSet(query, parameters);
                GridPurchases.DataSource = ds;
                GridPurchases.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading purchases: " + ex.Message);
            }
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            BindGrid(TxtSearch.Text.Trim());
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            TxtSearch.Text = "";
            BindGrid();
        }

        protected void GridPurchases_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridPurchases.PageIndex = e.NewPageIndex;
            BindGrid(TxtSearch.Text.Trim());
        }

        private void ResetForm()
        {
            DdlSupplier.SelectedIndex = 0;
            DdlProduct.SelectedIndex = 0;
            TxtPrice.Text = "";
            TxtQuantity.Text = "";
            TxtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            AlertPanel.Visible = false;
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }
    }
}