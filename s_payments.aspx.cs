using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class s_payments : System.Web.UI.Page
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
                LoadStatsAndGrid();
            }
        }

        private void LoadStatsAndGrid()
        {
            string sid = Session["sid"].ToString();
            try
            {
                // Get Paid sum
                string paidQuery = "SELECT SUM(Quantity * PurchasePrice) FROM Purchases WHERE SupplierId = @SupplierId AND PaymentStatus = 'Paid'";
                SqlParameter[] paidParam = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                object paidObj = dc.ExecuteScalar(paidQuery, paidParam);
                LblTotalPaid.Text = (paidObj != DBNull.Value && paidObj != null) ? Convert.ToDecimal(paidObj).ToString("N2") : "0.00";

                // Get Pending sum
                string pendQuery = "SELECT SUM(Quantity * PurchasePrice) FROM Purchases WHERE SupplierId = @SupplierId AND PaymentStatus = 'Pending'";
                SqlParameter[] pendParam = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                object pendObj = dc.ExecuteScalar(pendQuery, pendParam);
                LblTotalPending.Text = (pendObj != DBNull.Value && pendObj != null) ? Convert.ToDecimal(pendObj).ToString("N2") : "0.00";

                // Load Grid
                string query = @"SELECT p.PurchaseId, p.PurchaseDate, prod.ProductName, p.Quantity, p.PurchasePrice, p.PaymentStatus 
                                 FROM Purchases p
                                 INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                                 WHERE p.SupplierId = @SupplierId
                                 ORDER BY p.PurchaseDate DESC";
                SqlParameter[] gridParam = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                GvPayments.DataSource = dc.GetDataSet(query, gridParam).Tables[0];
                GvPayments.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading payments: " + ex.Message + "')</script>");
            }
        }

        protected void GvPayments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "PrintReceipt")
            {
                int poId = Convert.ToInt32(e.CommandArgument);
                LoadReceiptDetails(poId);
            }
        }

        private void LoadReceiptDetails(int poId)
        {
            try
            {
                string query = @"SELECT p.PurchaseId, p.PurchaseDate, p.Quantity, p.PurchasePrice, prod.ProductName, p.SupplierId
                                 FROM Purchases p
                                 INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                                 WHERE p.PurchaseId = @PurchaseId";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@PurchaseId", poId) };
                DataSet ds = dc.GetDataSet(query, param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    PrintReceiptPoId.Text = row["PurchaseId"].ToString();
                    PrintReceiptDate.Text = Convert.ToDateTime(row["PurchaseDate"]).ToString("dd-MM-yyyy");
                    PrintReceiptSupp.Text = row["SupplierId"].ToString();
                    PrintReceiptProd.Text = row["ProductName"].ToString();
                    PrintReceiptQty.Text = row["Quantity"].ToString();

                    decimal unit = Convert.ToDecimal(row["PurchasePrice"]);
                    int qty = Convert.ToInt32(row["Quantity"]);
                    PrintReceiptTotal.Text = (unit * qty).ToString("N2");

                    PanelReceiptOverlay.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error rendering receipt: " + ex.Message + "')</script>");
            }
        }

        protected void BtnCloseReceipt_Click(object sender, EventArgs e)
        {
            PanelReceiptOverlay.Visible = false;
        }
    }
}
