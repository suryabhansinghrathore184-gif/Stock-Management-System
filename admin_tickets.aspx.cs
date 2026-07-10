using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class admin_tickets : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTickets();
            }
        }

        private void LoadTickets()
        {
            try
            {
                string statusFilter = DdlFilterStatus.SelectedValue;
                string query = "SELECT TicketId, UserId, UserRole, Subject, Status, CreatedDate FROM SupportTickets";
                SqlParameter[] param = null;

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    query += " WHERE Status = @Status";
                    param = new SqlParameter[] { new SqlParameter("@Status", statusFilter) };
                }

                query += " ORDER BY CreatedDate DESC";

                DataSet ds = (param != null) ? dc.GetDataSet(query, param) : dc.GetDataSet(query);
                GvTickets.DataSource = ds.Tables[0];
                GvTickets.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading tickets: " + ex.Message);
            }
        }

        protected void DdlFilterStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTickets();
            PanelChat.Visible = false;
            PanelNoTicket.Visible = true;
        }

        protected void GvTickets_SelectedIndexChanged(object sender, EventArgs e)
        {
            int ticketId = Convert.ToInt32(GvTickets.SelectedDataKey.Value);
            LoadTicketDetails(ticketId);
        }

        private void LoadTicketDetails(int ticketId)
        {
            try
            {
                string query = "SELECT TicketId, UserId, UserRole, Subject, Status FROM SupportTickets WHERE TicketId = @Id";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", ticketId) };
                DataSet ds = dc.GetDataSet(query, param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    LblTicketId.Text = row["TicketId"].ToString();
                    LblTicketUser.Text = row["UserId"].ToString();
                    LblTicketRole.Text = row["UserRole"].ToString();
                    LblTicketSubject.Text = row["Subject"].ToString();
                    DdlTicketStatus.SelectedValue = row["Status"].ToString();

                    LoadReplies(ticketId);

                    PanelChat.Visible = true;
                    PanelNoTicket.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading ticket details: " + ex.Message);
            }
        }

        private void LoadReplies(int ticketId)
        {
            try
            {
                string query = "SELECT SenderId, Message, CreatedDate FROM TicketReplies WHERE TicketId = @TicketId ORDER BY CreatedDate ASC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@TicketId", ticketId) };
                RpReplies.DataSource = dc.GetDataSet(query, param).Tables[0];
                RpReplies.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading replies: " + ex.Message);
            }
        }

        protected void BtnSendReply_Click(object sender, EventArgs e)
        {
            string ticketIdStr = LblTicketId.Text;
            string message = TxtReply.Text.Trim();

            if (string.IsNullOrEmpty(ticketIdStr) || string.IsNullOrEmpty(message))
            {
                return;
            }

            int ticketId = Convert.ToInt32(ticketIdStr);

            try
            {
                // Insert reply
                string query = "INSERT INTO TicketReplies (TicketId, SenderId, Message, CreatedDate) VALUES (@TicketId, 'Admin', @Message, GETDATE())";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@TicketId", ticketId),
                    new SqlParameter("@Message", message)
                };
                dc.ExecuteNonQuery(query, param);

                // Update updated date of ticket
                string uQuery = "UPDATE SupportTickets SET UpdatedDate = GETDATE() WHERE TicketId = @TicketId";
                dc.ExecuteNonQuery(uQuery, new SqlParameter[] { new SqlParameter("@TicketId", ticketId) });

                TxtReply.Text = "";
                LoadReplies(ticketId);
            }
            catch (Exception ex)
            {
                ShowAlert("Error sending reply: " + ex.Message);
            }
        }

        protected void DdlTicketStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            string ticketIdStr = LblTicketId.Text;
            string status = DdlTicketStatus.SelectedValue;

            if (string.IsNullOrEmpty(ticketIdStr))
            {
                return;
            }

            int ticketId = Convert.ToInt32(ticketIdStr);

            try
            {
                string query = "UPDATE SupportTickets SET Status = @Status, UpdatedDate = GETDATE() WHERE TicketId = @TicketId";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Status", status),
                    new SqlParameter("@TicketId", ticketId)
                };
                dc.ExecuteNonQuery(query, param);

                // Add system notification for the user
                string userId = LblTicketUser.Text;
                string userRole = LblTicketRole.Text;
                string nInsert = "INSERT INTO CustomerNotifications (UserId, UserRole, Title, Message, IsRead, CreatedDate) VALUES (@UserId, @UserRole, 'Support Ticket Update', @Message, 0, GETDATE())";
                dc.ExecuteNonQuery(nInsert, new SqlParameter[]
                {
                    new SqlParameter("@UserId", userId),
                    new SqlParameter("@UserRole", userRole),
                    new SqlParameter("@Message", "Your support ticket (ID: " + ticketId + ") status has been updated to '" + status + "'.")
                });

                ShowAlert("Ticket status updated to " + status + "!");
                LoadTickets();
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating status: " + ex.Message);
            }
        }

        protected void GvTickets_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GvTickets.PageIndex = e.NewPageIndex;
            LoadTickets();
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}
