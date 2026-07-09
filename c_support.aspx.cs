using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class c_support : System.Web.UI.Page
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
                LoadTickets();
            }
        }

        private void LoadTickets()
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = "SELECT TicketId, Subject, Category, Status FROM SupportTickets WHERE UserId = @UserId AND UserRole = 'Customer' ORDER BY CreatedDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@UserId", cid) };
                GvTickets.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvTickets.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading tickets: " + ex.Message);
            }
        }

        protected void BtnSubmitTicket_Click(object sender, EventArgs e)
        {
            string cid = Session["cid"].ToString();
            string subject = TxtSubject.Text.Trim();
            string category = DdlCategory.SelectedValue;
            string desc = TxtDesc.Text.Trim();

            if (string.IsNullOrEmpty(subject) || string.IsNullOrEmpty(desc))
            {
                ShowAlert("Please enter a subject and detailed description.");
                return;
            }

            try
            {
                // 1. Create Ticket
                string tInsert = "INSERT INTO SupportTickets (UserId, UserRole, Subject, Category, Status, CreatedDate, UpdatedDate) VALUES (@UserId, 'Customer', @Subject, @Category, 'Open', GETDATE(), GETDATE()); SELECT SCOPE_IDENTITY();";
                SqlParameter[] tParams = new SqlParameter[]
                {
                    new SqlParameter("@UserId", cid),
                    new SqlParameter("@Subject", subject),
                    new SqlParameter("@Category", category)
                };
                object ticketId = dc.ExecuteScalar(tInsert, tParams);

                if (ticketId != null)
                {
                    int id = Convert.ToInt32(ticketId);

                    // 2. Insert Description as Initial Reply
                    string rInsert = "INSERT INTO TicketReplies (TicketId, SenderId, Message, CreatedDate) VALUES (@TicketId, @SenderId, @Message, GETDATE())";
                    SqlParameter[] rParams = new SqlParameter[]
                    {
                        new SqlParameter("@TicketId", id),
                        new SqlParameter("@SenderId", cid),
                        new SqlParameter("@Message", desc)
                    };
                    dc.ExecuteNonQuery(rInsert, rParams);

                    // 3. Create Notification
                    string nInsert = "INSERT INTO CustomerNotifications (UserId, UserRole, Title, Message, IsRead, CreatedDate) VALUES (@CustomerId, 'Customer', 'Ticket Submitted', @Message, 0, GETDATE())";
                    dc.ExecuteNonQuery(nInsert, new SqlParameter[]
                    {
                        new SqlParameter("@CustomerId", cid),
                        new SqlParameter("@Message", "Your support ticket regarding " + subject + " has been successfully submitted (ID: " + id + ").")
                    });

                    ShowAlert("Support ticket submitted successfully! Ticket ID: " + id);
                    TxtSubject.Text = "";
                    TxtDesc.Text = "";
                    LoadTickets();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error submitting ticket: " + ex.Message);
            }
        }

        protected void GvTickets_SelectedIndexChanged(object sender, EventArgs e)
        {
            int ticketId = Convert.ToInt32(GvTickets.SelectedDataKey.Value);
            LblSelectedTicketId.Text = ticketId.ToString();
            PanelChat.Visible = true;
            LoadReplies(ticketId);
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
            string cid = Session["cid"].ToString();
            string ticketIdStr = LblSelectedTicketId.Text;
            string message = TxtReply.Text.Trim();

            if (string.IsNullOrEmpty(ticketIdStr) || string.IsNullOrEmpty(message))
            {
                return;
            }

            int ticketId = Convert.ToInt32(ticketIdStr);

            try
            {
                // 1. Insert Reply
                string query = "INSERT INTO TicketReplies (TicketId, SenderId, Message, CreatedDate) VALUES (@TicketId, @SenderId, @Message, GETDATE())";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@TicketId", ticketId),
                    new SqlParameter("@SenderId", cid),
                    new SqlParameter("@Message", message)
                };
                dc.ExecuteNonQuery(query, param);

                // 2. Update Ticket Modified Date
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

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}
