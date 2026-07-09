using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class WebForm8 : System.Web.UI.Page
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
                // Customers Dropdown
                DataSet dsCust = dc.GetDataSet("SELECT Id, name FROM NewCustomer WHERE status = 'Active' ORDER BY name ASC");
                DdlCustomer.DataSource = dsCust;
                DdlCustomer.DataTextField = "name";
                DdlCustomer.DataValueField = "Id";
                DdlCustomer.DataBind();
                DdlCustomer.Items.Insert(0, new ListItem("-- Select Customer --", ""));

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
                    string query = "SELECT SellingPrice, Quantity FROM Products WHERE ProductCode = @ProductCode";
                    SqlParameter[] param = new SqlParameter[]
                    {
                        new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode }
                    };
                    DataSet ds = dc.GetDataSet(query, param);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataRow row = ds.Tables[0].Rows[0];
                        TxtPrice.Text = Convert.ToDecimal(row["SellingPrice"]).ToString("0.00");
                        int stock = Convert.ToInt32(row["Quantity"]);
                        StockLabel.Text = "Available Stock: <span class='badge bg-info'>" + stock + "</span>";
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading product details: " + ex.Message);
                }
            }
            else
            {
                TxtPrice.Text = "";
                StockLabel.Text = "";
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string customerId = DdlCustomer.SelectedValue;
            string productCode = DdlProduct.SelectedValue;
            decimal price = 0;
            int quantity = 0;
            decimal discount = 0;
            decimal gstRate = 18;

            decimal.TryParse(TxtPrice.Text, out price);
            int.TryParse(TxtQuantity.Text, out quantity);
            decimal.TryParse(TxtDiscount.Text, out discount);
            decimal.TryParse(TxtGstRate.Text, out gstRate);

            if (string.IsNullOrEmpty(customerId) || string.IsNullOrEmpty(productCode) || price <= 0 || quantity <= 0)
            {
                ShowAlert("Please enter valid sales details.");
                return;
            }

            try
            {
                // 1. Stock check
                string checkStockQuery = "SELECT Quantity FROM Products WHERE ProductCode = @ProductCode";
                SqlParameter[] checkParams = new SqlParameter[]
                {
                    new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode }
                };
                int currentStock = Convert.ToInt32(dc.ExecuteScalar(checkStockQuery, checkParams));
                if (quantity > currentStock)
                {
                    ShowAlert("Insufficient stock. Only " + currentStock + " items left in inventory.");
                    return;
                }

                // 2. Generate Invoice Number
                string invoiceNumber = GenerateInvoiceNumber();

                // 3. Compute final math
                decimal subtotal = (price * quantity) - discount;
                if (subtotal < 0) subtotal = 0;
                decimal total = subtotal + (subtotal * (gstRate / 100));

                // 4. Create transaction commands
                List<SqlCommand> commandList = new List<SqlCommand>();

                // Insert into Sales Table
                SqlCommand cmdSale = new SqlCommand(@"INSERT INTO Sales (InvoiceNumber, CustomerId, ProductCode, Quantity, SellingPrice, Discount, GST, Total, SaleDate)
                                                      VALUES (@InvoiceNumber, @CustomerId, @ProductCode, @Quantity, @SellingPrice, @Discount, @GST, @Total, GETDATE())");
                cmdSale.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber);
                cmdSale.Parameters.AddWithValue("@CustomerId", customerId);
                cmdSale.Parameters.AddWithValue("@ProductCode", productCode);
                cmdSale.Parameters.AddWithValue("@Quantity", quantity);
                cmdSale.Parameters.AddWithValue("@SellingPrice", price);
                cmdSale.Parameters.AddWithValue("@Discount", discount);
                cmdSale.Parameters.AddWithValue("@GST", gstRate);
                cmdSale.Parameters.AddWithValue("@Total", total);
                commandList.Add(cmdSale);

                // Decrease Stock in Products Table
                SqlCommand cmdUpdateStock = new SqlCommand(@"UPDATE Products SET Quantity = Quantity - @Quantity WHERE ProductCode = @ProductCode");
                cmdUpdateStock.Parameters.AddWithValue("@Quantity", quantity);
                cmdUpdateStock.Parameters.AddWithValue("@ProductCode", productCode);
                commandList.Add(cmdUpdateStock);

                // Log into StockHistory
                SqlCommand cmdHistory = new SqlCommand(@"INSERT INTO StockHistory (ProductCode, ChangeType, Quantity, Remarks)
                                                         VALUES (@ProductCode, 'Sale', @Quantity, @Remarks)");
                cmdHistory.Parameters.AddWithValue("@ProductCode", productCode);
                cmdHistory.Parameters.AddWithValue("@Quantity", -quantity);
                cmdHistory.Parameters.AddWithValue("@Remarks", "Sold under invoice: " + invoiceNumber + " to Customer: " + DdlCustomer.SelectedItem.Text);
                commandList.Add(cmdHistory);

                // Execute Transaction
                bool success = dc.ExecuteTransaction(commandList);
                if (success)
                {
                    // Success alert + auto print trigger
                    string script = "Swal.fire({ title: 'Success!', text: 'Sale registered successfully. Invoice generated: " + invoiceNumber + "', icon: 'success' }).then(() => { window.open('print_invoice.aspx?invoice=" + invoiceNumber + "', '_blank'); });";
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", script, true);
                    ResetForm();
                    BindGrid();
                }
                else
                {
                    ShowAlert("Failed to complete sale transaction.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error recording sale: " + ex.Message);
            }
        }

        private string GenerateInvoiceNumber()
        {
            try
            {
                string year = DateTime.Now.Year.ToString();
                string query = "SELECT MAX(InvoiceNumber) FROM Sales WHERE InvoiceNumber LIKE 'INV-' + @Year + '-%'";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Year", SqlDbType.VarChar) { Value = year }
                };
                object maxVal = dc.ExecuteScalar(query, param);

                if (maxVal == null || maxVal == DBNull.Value)
                {
                    return "INV-" + year + "-1001";
                }
                else
                {
                    string lastInvoice = maxVal.ToString();
                    string[] parts = lastInvoice.Split('-');
                    int nextNum = Convert.ToInt32(parts[2]) + 1;
                    return "INV-" + year + "-" + nextNum.ToString();
                }
            }
            catch
            {
                // Fallback safe invoice number
                return "INV-" + DateTime.Now.ToString("yyyyMMddHHmmss");
            }
        }

        private void BindGrid(string search = "")
        {
            try
            {
                string query = @"SELECT s.SaleId, s.InvoiceNumber, s.Quantity, s.SellingPrice, s.Discount, s.Total,
                                       c.name as customername, prod.ProductName
                                FROM Sales s
                                INNER JOIN NewCustomer c ON s.CustomerId = c.Id
                                INNER JOIN Products prod ON s.ProductCode = prod.ProductCode";

                SqlParameter[] parameters = null;
                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE s.InvoiceNumber LIKE @Search OR c.name LIKE @Search";
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" }
                    };
                }

                query += " ORDER BY s.SaleDate DESC, s.SaleId DESC";
                DataSet ds = dc.GetDataSet(query, parameters);
                GridSales.DataSource = ds;
                GridSales.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading sales: " + ex.Message);
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

        protected void GridSales_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridSales.PageIndex = e.NewPageIndex;
            BindGrid(TxtSearch.Text.Trim());
        }

        protected void GridSales_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Print action handled by client HTML links directly
        }

        private void ResetForm()
        {
            DdlCustomer.SelectedIndex = 0;
            DdlProduct.SelectedIndex = 0;
            TxtPrice.Text = "";
            TxtQuantity.Text = "";
            TxtDiscount.Text = "0.00";
            TxtGstRate.Text = "18";
            StockLabel.Text = "";
            AlertPanel.Visible = false;
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }
    }
}