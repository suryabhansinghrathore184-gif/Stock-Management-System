using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class s_deliveryschedule : System.Web.UI.Page
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
                LoadDeliveries();
            }
        }

        private void LoadDeliveries()
        {
            string sid = Session["sid"].ToString();
            try
            {
                string query = @"SELECT p.PurchaseId, p.PurchaseDate, prod.ProductName, p.Quantity, p.DeliveryStatus 
                                 FROM Purchases p
                                 INNER JOIN Products prod ON p.ProductCode = prod.ProductCode
                                 WHERE p.SupplierId = @SupplierId
                                 ORDER BY p.PurchaseDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SupplierId", sid) };
                GvSchedule.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvSchedule.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading deliveries: " + ex.Message + "')</script>");
            }
        }

        protected void GvSchedule_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GvSchedule.EditIndex = e.NewEditIndex;
            LoadDeliveries();
        }

        protected void GvSchedule_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GvSchedule.EditIndex = -1;
            LoadDeliveries();
        }

        protected void GvSchedule_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int poId = Convert.ToInt32(GvSchedule.DataKeys[e.RowIndex].Value);
            
            GridViewRow row = GvSchedule.Rows[e.RowIndex];
            DropDownList ddlStatus = (DropDownList)row.FindControl("DdlEditStatus");

            if (ddlStatus == null)
            {
                return;
            }

            string status = ddlStatus.SelectedValue;

            try
            {
                string query = "UPDATE Purchases SET DeliveryStatus = @Status WHERE PurchaseId = @PurchaseId";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Status", status),
                    new SqlParameter("@PurchaseId", poId)
                };
                dc.ExecuteNonQuery(query, param);

                GvSchedule.EditIndex = -1;
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Delivery status updated successfully!');", true);
                LoadDeliveries();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }
    }
}
