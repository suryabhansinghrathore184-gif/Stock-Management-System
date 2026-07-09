using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class s_dashboard : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();
        public int DeliveredCount = 0;
        public int PendingCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["sid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadRecentSupplies();
            }
        }

        private void LoadStats()
        {
            string sid = Session["sid"].ToString();
            try
            {
                // Get supplier name
                string nameQuery = "SELECT suppliername FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] nameParam = new SqlParameter[] { new SqlParameter("@Id", sid) };
                object nameObj = dc.ExecuteScalar(nameQuery, nameParam);
                if (nameObj != null)
                {
                    LblSupplierName.Text = nameObj.ToString();
                }

                // Get supplied products count
                string prodQuery = "SELECT COUNT(*) FROM Products WHERE SupplierId = @SupplierId";
                SqlParameter[] prodParam = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                LblTotalProducts.Text = dc.ExecuteScalar(prodQuery, prodParam).ToString();

                // Get Total Revenue (Sum of Quantity * PurchasePrice in Purchases)
                string revQuery = "SELECT SUM(Quantity * PurchasePrice) FROM Purchases WHERE SupplierId = @SupplierId";
                SqlParameter[] revParam = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                object revObj = dc.ExecuteScalar(revQuery, revParam);
                if (revObj != DBNull.Value && revObj != null)
                {
                    LblRevenue.Text = Convert.ToDecimal(revObj).ToString("N2");
                }
                else
                {
                    LblRevenue.Text = "0.00";
                }

                // Get Delivery Metrics
                string pendQuery = "SELECT COUNT(*) FROM Purchases WHERE SupplierId = @SupplierId AND DeliveryStatus IN ('Pending', 'In Transit')";
                SqlParameter[] pendParam = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                PendingCount = Convert.ToInt32(dc.ExecuteScalar(pendQuery, pendParam));
                LblPendingShipments.Text = PendingCount.ToString();

                string delQuery = "SELECT COUNT(*) FROM Purchases WHERE SupplierId = @SupplierId AND DeliveryStatus = 'Delivered'";
                SqlParameter[] delParam = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                DeliveredCount = Convert.ToInt32(dc.ExecuteScalar(delQuery, delParam));
                LblCompletedShipments.Text = DeliveredCount.ToString();
            }
            catch
            {
                LblTotalProducts.Text = "0";
                LblRevenue.Text = "0.00";
                LblPendingShipments.Text = "0";
                LblCompletedShipments.Text = "0";
            }
        }

        private void LoadRecentSupplies()
        {
            string sid = Session["sid"].ToString();
            try
            {
                string query = @"SELECT TOP 5 p.PurchaseId, prod.ProductName, p.Quantity, p.PurchasePrice, p.DeliveryStatus 
                                 FROM Purchases p
                                 INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                                 WHERE p.SupplierId = @SupplierId
                                 ORDER BY p.PurchaseDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                DataSet ds = dc.GetDataSet(query, param);
                GvRecentSupplies.DataSource = ds.Tables[0];
                GvRecentSupplies.DataBind();
            }
            catch
            {
                // Ignore
            }
        }
    }
}
