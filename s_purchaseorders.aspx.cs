using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class s_purchaseorders : System.Web.UI.Page
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
                LoadPOs();
            }
        }

        private void LoadPOs()
        {
            string sid = Session["sid"].ToString();
            try
            {
                string query = @"SELECT p.PurchaseId, p.PurchaseDate, prod.ProductName, p.Quantity, p.PurchasePrice, p.DeliveryStatus 
                                 FROM Purchases p
                                 INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                                 WHERE p.SupplierId = @SupplierId
                                 ORDER BY p.PurchaseDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                GvPOs.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvPOs.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading POs: " + ex.Message + "')</script>");
            }
        }

        protected void GvPOs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "PrintPO")
            {
                int poId = Convert.ToInt32(e.CommandArgument);
                LoadPoPrintDetails(poId);
            }
        }

        private void LoadPoPrintDetails(int poId)
        {
            try
            {
                string query = @"SELECT p.PurchaseId, p.Quantity, p.PurchasePrice, p.DeliveryStatus, prod.ProductName, 
                                        s.suppliername, s.companyname, s.email, s.address, s.gstnumber
                                 FROM Purchases p
                                 INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                                 INNER JOIN NewSupplier s ON p.SupplierId = s.supplierid
                                 WHERE p.PurchaseId = @PurchaseId";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@PurchaseId", poId) };
                DataSet ds = dc.GetDataSet(query, param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    PrintPoId.Text = row["PurchaseId"].ToString();
                    PrintCompName.Text = string.IsNullOrEmpty(row["companyname"].ToString()) ? "Supplier Company" : row["companyname"].ToString();
                    PrintGst.Text = string.IsNullOrEmpty(row["gstnumber"].ToString()) ? "N/A" : row["gstnumber"].ToString();

                    PrintSuppName.Text = row["suppliername"].ToString();
                    PrintSuppAddress.Text = row["address"].ToString();
                    PrintSuppEmail.Text = row["email"].ToString();

                    PrintProdName.Text = row["ProductName"].ToString();
                    PrintQty.Text = row["Quantity"].ToString();
                    
                    decimal unitPrice = Convert.ToDecimal(row["PurchasePrice"]);
                    int qty = Convert.ToInt32(row["Quantity"]);
                    
                    PrintUnit.Text = unitPrice.ToString("N2");
                    PrintTotal.Text = (unitPrice * qty).ToString("N2");
                    PrintStatus.Text = row["DeliveryStatus"].ToString();

                    PanelPrintOverlay.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error printing PO: " + ex.Message + "')</script>");
            }
        }

        protected void BtnClosePreview_Click(object sender, EventArgs e)
        {
            PanelPrintOverlay.Visible = false;
        }
    }
}
