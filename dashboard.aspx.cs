using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class dashboard : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        // Hidden fields properties for pie chart data mapping
        public int LblHealthyCountHidden { get; set; } = 0;
        public int LblLowStockCountHidden { get; set; } = 0;
        public int LblOutOfStockCountHidden { get; set; } = 0;

        // Chart data lists
        private List<string> monthlyLabels = new List<string>();
        private List<decimal> monthlySales = new List<decimal>();
        private List<decimal> monthlyPurchases = new List<decimal>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadKPICards();
                LoadRecentSales();
                CompileChartData();
            }
        }

        private void LoadKPICards()
        {
            try
            {
                // Counts
                LblTotalProducts.Text = dc.ExecuteScalar("SELECT COUNT(*) FROM Products").ToString();
                LblTotalCategories.Text = dc.ExecuteScalar("SELECT COUNT(*) FROM Categories WHERE Status = 'Active'").ToString();
                LblTotalCustomers.Text = dc.ExecuteScalar("SELECT COUNT(*) FROM NewCustomer WHERE status = 'Active'").ToString();
                LblTotalSuppliers.Text = dc.ExecuteScalar("SELECT COUNT(*) FROM NewSupplier WHERE supplierstatus = 'Active'").ToString();

                // Stock status
                int healthy = Convert.ToInt32(dc.ExecuteScalar("SELECT COUNT(*) FROM Products WHERE Quantity > 10"));
                int lowStock = Convert.ToInt32(dc.ExecuteScalar("SELECT COUNT(*) FROM Products WHERE Quantity <= 10 AND Quantity > 0"));
                int outStock = Convert.ToInt32(dc.ExecuteScalar("SELECT COUNT(*) FROM Products WHERE Quantity = 0"));

                LblHealthyCountHidden = healthy;
                LblLowStockCountHidden = lowStock;
                LblOutOfStockCountHidden = outStock;
                LblLowStockCount.Text = (lowStock + outStock).ToString();

                // Sales figures
                object todaySalesObj = dc.ExecuteScalar("SELECT SUM(Total) FROM Sales WHERE CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)");
                decimal todaySales = todaySalesObj != null && todaySalesObj != DBNull.Value ? Convert.ToDecimal(todaySalesObj) : 0;
                LblTodaySales.Text = todaySales.ToString("N2");

                object monthlySalesObj = dc.ExecuteScalar("SELECT SUM(Total) FROM Sales WHERE MONTH(SaleDate) = MONTH(GETDATE()) AND YEAR(SaleDate) = YEAR(GETDATE())");
                decimal monthlySalesVal = monthlySalesObj != null && monthlySalesObj != DBNull.Value ? Convert.ToDecimal(monthlySalesObj) : 0;
                LblMonthlySales.Text = monthlySalesVal.ToString("N2");
            }
            catch (Exception ex)
            {
                // Fail-safe defaults
                LblTotalProducts.Text = "0";
                LblTotalCategories.Text = "0";
                LblTotalCustomers.Text = "0";
                LblTotalSuppliers.Text = "0";
                LblTodaySales.Text = "0.00";
                LblMonthlySales.Text = "0.00";
                LblLowStockCount.Text = "0";
            }
        }

        private void LoadRecentSales()
        {
            try
            {
                string query = @"SELECT TOP 5 s.InvoiceNumber, s.Quantity, s.Total, s.SaleDate,
                                             c.name as customername, p.ProductName
                                FROM Sales s
                                INNER JOIN NewCustomer c ON s.CustomerId = c.Id
                                INNER JOIN Products p ON s.ProductCode = p.ProductCode
                                ORDER BY s.SaleDate DESC, s.SaleId DESC";

                DataSet ds = dc.GetDataSet(query);
                GridRecentSales.DataSource = ds;
                GridRecentSales.DataBind();
            }
            catch
            {
                // Grid remains empty
            }
        }

        private void CompileChartData()
        {
            // Build last 6 months labels
            DateTime start = DateTime.Now.AddMonths(-5);
            for (int i = 0; i < 6; i++)
            {
                DateTime dt = start.AddMonths(i);
                monthlyLabels.Add(dt.ToString("MMM yyyy"));
                
                // Fetch sales for this month
                decimal salesTotal = GetMonthSalesSum(dt.Month, dt.Year);
                monthlySales.Add(salesTotal);

                // Fetch purchases for this month
                decimal purchasesTotal = GetMonthPurchasesSum(dt.Month, dt.Year);
                monthlyPurchases.Add(purchasesTotal);
            }
        }

        private decimal GetMonthSalesSum(int month, int year)
        {
            try
            {
                string query = "SELECT SUM(Total) FROM Sales WHERE MONTH(SaleDate) = @Month AND YEAR(SaleDate) = @Year";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Month", SqlDbType.Int) { Value = month },
                    new SqlParameter("@Year", SqlDbType.Int) { Value = year }
                };
                object obj = dc.ExecuteScalar(query, param);
                return obj != null && obj != DBNull.Value ? Convert.ToDecimal(obj) : 0;
            }
            catch
            {
                return 0;
            }
        }

        private decimal GetMonthPurchasesSum(int month, int year)
        {
            try
            {
                string query = "SELECT SUM(Quantity * PurchasePrice) FROM Purchases WHERE MONTH(PurchaseDate) = @Month AND YEAR(PurchaseDate) = @Year";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Month", SqlDbType.Int) { Value = month },
                    new SqlParameter("@Year", SqlDbType.Int) { Value = year }
                };
                object obj = dc.ExecuteScalar(query, param);
                return obj != null && obj != DBNull.Value ? Convert.ToDecimal(obj) : 0;
            }
            catch
            {
                return 0;
            }
        }

        // Helper methods for ASPX script to fetch Chart JSON
        public string GetMonthlyLabelsJson()
        {
            return new JavaScriptSerializer().Serialize(monthlyLabels);
        }

        public string GetMonthlySalesDataJson()
        {
            return new JavaScriptSerializer().Serialize(monthlySales);
        }

        public string GetMonthlyPurchasesDataJson()
        {
            return new JavaScriptSerializer().Serialize(monthlyPurchases);
        }
    }
}
