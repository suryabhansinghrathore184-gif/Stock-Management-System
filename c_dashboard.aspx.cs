using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class c_dashboard : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();
        public int CompletedCount = 0;
        public int PendingCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadRecentOrders();
            }
        }

        private void LoadStats()
        {
            string cid = Session["cid"].ToString();
            try
            {
                // Get customer name
                string nameQuery = "SELECT name FROM NewCustomer WHERE Id = @Id";
                SqlParameter[] nameParam = new SqlParameter[] { new SqlParameter("@Id", cid) };
                object nameObj = dc.ExecuteScalar(nameQuery, nameParam);
                if (nameObj != null)
                {
                    LblCustomerName.Text = nameObj.ToString();
                }

                // Get Total Orders & Spent
                string statsQuery = @"SELECT COUNT(DISTINCT InvoiceNumber) as TotalOrders, SUM(Total) as TotalSpent 
                                      FROM Sales WHERE CustomerId = @CustomerId";
                SqlParameter[] statsParam = new SqlParameter[] { new SqlParameter("@CustomerId", cid) };
                DataSet dsStats = dc.GetDataSet(statsQuery, statsParam);
                if (dsStats.Tables[0].Rows.Count > 0 && dsStats.Tables[0].Rows[0]["TotalOrders"] != DBNull.Value)
                {
                    LblTotalOrders.Text = dsStats.Tables[0].Rows[0]["TotalOrders"].ToString();
                    LblAmountSpent.Text = Convert.ToDecimal(dsStats.Tables[0].Rows[0]["TotalSpent"]).ToString("N2");
                }

                // Get status metrics
                string pendingQuery = "SELECT COUNT(DISTINCT InvoiceNumber) FROM Sales WHERE CustomerId = @CustomerId AND OrderStatus = 'Pending'";
                SqlParameter[] pendingParam = new SqlParameter[] { new SqlParameter("@CustomerId", cid) };
                PendingCount = Convert.ToInt32(dc.ExecuteScalar(pendingQuery, pendingParam));
                LblPendingOrders.Text = PendingCount.ToString();

                string completedQuery = "SELECT COUNT(DISTINCT InvoiceNumber) FROM Sales WHERE CustomerId = @CustomerId AND OrderStatus = 'Completed'";
                SqlParameter[] completedParam = new SqlParameter[] { new SqlParameter("@CustomerId", cid) };
                CompletedCount = Convert.ToInt32(dc.ExecuteScalar(completedQuery, completedParam));
                LblCompletedOrders.Text = CompletedCount.ToString();
            }
            catch (Exception ex)
            {
                // Fallback
                LblTotalOrders.Text = "0";
                LblAmountSpent.Text = "0.00";
            }
        }

        private void LoadRecentOrders()
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = @"SELECT TOP 5 InvoiceNumber, p.ProductName, s.Total, s.OrderStatus 
                                 FROM Sales s
                                 INNER JOIN Products p ON s.ProductCode = p.ProductCode
                                 WHERE s.CustomerId = @CustomerId
                                 ORDER BY s.SaleDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@CustomerId", cid) };
                DataSet ds = dc.GetDataSet(query, param);
                GvRecentOrders.DataSource = ds.Tables[0];
                GvRecentOrders.DataBind();
            }
            catch
            {
                // Ignore
            }
        }
    }
}
