using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class c_notifications : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindNotifications();
            }
        }

        private void BindNotifications()
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = "SELECT Id, Title, Message, IsRead, CreatedDate FROM CustomerNotifications WHERE UserId = @UserId ORDER BY CreatedDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@UserId", cid) };
                RpNotifications.DataSource = dc.GetDataSet(query, param).Tables[0];
                RpNotifications.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading notifications: " + ex.Message + "')</script>");
            }
        }

        protected void RpNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "MarkRead")
            {
                int notifId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    string query = "UPDATE CustomerNotifications SET IsRead = 1 WHERE Id = @Id";
                    SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", notifId) };
                    dc.ExecuteNonQuery(query, param);
                    BindNotifications();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message + "')</script>");
                }
            }
        }

        protected void BtnMarkAllRead_Click(object sender, EventArgs e)
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = "UPDATE CustomerNotifications SET IsRead = 1 WHERE UserId = @UserId AND IsRead = 0";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@UserId", cid) };
                dc.ExecuteNonQuery(query, param);
                BindNotifications();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "')</script>");
            }
        }

        protected void BtnClearAll_Click(object sender, EventArgs e)
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = "DELETE FROM CustomerNotifications WHERE UserId = @UserId";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@UserId", cid) };
                dc.ExecuteNonQuery(query, param);
                BindNotifications();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "')</script>");
            }
        }
    }
}
