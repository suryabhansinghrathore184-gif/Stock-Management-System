using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class stock : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDropdown();
                UpdateKPIs();
                BindStockGrid();
                BindHistoryGrid();
            }
        }

        private void BindDropdown()
        {
            try
            {
                DataSet dsProd = dc.GetDataSet("SELECT ProductCode, ProductName FROM Products ORDER BY ProductName ASC");
                DdlProduct.DataSource = dsProd;
                DdlProduct.DataTextField = "ProductName";
                DdlProduct.DataValueField = "ProductCode";
                DdlProduct.DataBind();
                DdlProduct.Items.Insert(0, new ListItem("-- Select Product --", ""));
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading products: " + ex.Message);
            }
        }

        private void UpdateKPIs()
        {
            try
            {
                // KPI Calculations
                object healthyVal = dc.ExecuteScalar("SELECT COUNT(*) FROM Products WHERE Quantity > 10");
                object lowStockVal = dc.ExecuteScalar("SELECT COUNT(*) FROM Products WHERE Quantity <= 10 AND Quantity > 0");
                object outStockVal = dc.ExecuteScalar("SELECT COUNT(*) FROM Products WHERE Quantity = 0");

                LblHealthyCount.Text = healthyVal != null ? healthyVal.ToString() : "0";
                LblLowStockCount.Text = lowStockVal != null ? lowStockVal.ToString() : "0";
                LblOutOfStockCount.Text = outStockVal != null ? outStockVal.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading stock indicators: " + ex.Message);
            }
        }

        protected void DdlProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            string productCode = DdlProduct.SelectedValue;
            if (!string.IsNullOrEmpty(productCode))
            {
                try
                {
                    object qty = dc.ExecuteScalar("SELECT Quantity FROM Products WHERE ProductCode = @ProductCode", 
                        new SqlParameter[] { new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode } });
                    CurrentStockLabel.Text = "Current Stock Level: <span class='fw-bold'>" + (qty != null ? qty.ToString() : "0") + "</span>";
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading stock: " + ex.Message);
                }
            }
            else
            {
                CurrentStockLabel.Text = "";
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string productCode = DdlProduct.SelectedValue;
            string adjType = DdlAdjType.SelectedValue;
            int quantity = 0;
            string remarks = TxtRemarks.Text.Trim();

            int.TryParse(TxtQuantity.Text, out quantity);

            if (string.IsNullOrEmpty(productCode) || quantity <= 0 || string.IsNullOrEmpty(remarks))
            {
                ShowAlert("Please fill in all adjustment fields correctly.");
                return;
            }

            try
            {
                // Fetch current stock
                string checkQuery = "SELECT Quantity FROM Products WHERE ProductCode = @ProductCode";
                SqlParameter[] checkParams = new SqlParameter[] { new SqlParameter("@ProductCode", SqlDbType.VarChar) { Value = productCode } };
                int currentQty = Convert.ToInt32(dc.ExecuteScalar(checkQuery, checkParams));

                int finalChange = adjType == "Addition" ? quantity : -quantity;
                int prospectiveStock = currentQty + finalChange;

                if (prospectiveStock < 0)
                {
                    ShowAlert("Cannot adjust stock. Prospective stock level would fall below 0 (Currently " + currentQty + ").");
                    return;
                }

                // Prepare Commands
                List<SqlCommand> commandList = new List<SqlCommand>();

                // 1. Update Product Qty
                SqlCommand cmdUpdate = new SqlCommand("UPDATE Products SET Quantity = @ProspectiveStock WHERE ProductCode = @ProductCode");
                cmdUpdate.Parameters.AddWithValue("@ProspectiveStock", prospectiveStock);
                cmdUpdate.Parameters.AddWithValue("@ProductCode", productCode);
                commandList.Add(cmdUpdate);

                // 2. Insert StockHistory
                SqlCommand cmdHistory = new SqlCommand("INSERT INTO StockHistory (ProductCode, ChangeType, Quantity, Remarks) VALUES (@ProductCode, 'Adjustment', @Quantity, @Remarks)");
                cmdHistory.Parameters.AddWithValue("@ProductCode", productCode);
                cmdHistory.Parameters.AddWithValue("@Quantity", finalChange);
                cmdHistory.Parameters.AddWithValue("@Remarks", remarks);
                commandList.Add(cmdHistory);

                // Execute
                bool success = dc.ExecuteTransaction(commandList);
                if (success)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Success!', 'Stock level adjusted successfully.', 'success');", true);
                    ResetForm();
                    UpdateKPIs();
                    BindStockGrid();
                    BindHistoryGrid();
                }
                else
                {
                    ShowAlert("Failed to complete stock adjustment transaction.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating stock: " + ex.Message);
            }
        }

        private void BindStockGrid(string search = "")
        {
            try
            {
                string query = @"SELECT p.ProductCode, p.ProductName, p.Quantity, c.CategoryName
                                FROM Products p
                                INNER JOIN Categories c ON p.CategoryId = c.CategoryId";

                SqlParameter[] parameters = null;
                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE p.ProductCode LIKE @Search OR p.ProductName LIKE @Search OR c.CategoryName LIKE @Search";
                    parameters = new SqlParameter[] { new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" } };
                }

                query += " ORDER BY p.ProductName ASC";
                DataSet ds = dc.GetDataSet(query, parameters);
                GridStock.DataSource = ds;
                GridStock.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading stock: " + ex.Message);
            }
        }

        private void BindHistoryGrid(string search = "")
        {
            try
            {
                string query = @"SELECT h.HistoryId, h.ChangeType, h.Quantity, h.Remarks, h.ChangeDate, p.ProductName
                                FROM StockHistory h
                                INNER JOIN Products p ON h.ProductCode = p.ProductCode";

                SqlParameter[] parameters = null;
                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE p.ProductName LIKE @Search OR h.Remarks LIKE @Search";
                    parameters = new SqlParameter[] { new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" } };
                }

                query += " ORDER BY h.ChangeDate DESC, h.HistoryId DESC";
                DataSet ds = dc.GetDataSet(query, parameters);
                GridHistory.DataSource = ds;
                GridHistory.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading audit history: " + ex.Message);
            }
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
            string search = TxtSearch.Text.Trim();
            BindStockGrid(search);
            BindHistoryGrid(search);
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            TxtSearch.Text = "";
            BindStockGrid();
            BindHistoryGrid();
        }

        protected void GridStock_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridStock.PageIndex = e.NewPageIndex;
            BindStockGrid(TxtSearch.Text.Trim());
        }

        protected void GridHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridHistory.PageIndex = e.NewPageIndex;
            BindHistoryGrid(TxtSearch.Text.Trim());
        }

        private void ResetForm()
        {
            DdlProduct.SelectedIndex = 0;
            DdlAdjType.SelectedIndex = 0;
            TxtQuantity.Text = "";
            TxtRemarks.Text = "";
            CurrentStockLabel.Text = "";
            AlertPanel.Visible = false;
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }
    }
}
