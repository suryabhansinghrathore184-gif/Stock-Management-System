using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm11 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear any existing session to start fresh
                Session.Clear();
                Session.Abandon();
                
                // Set default security headers if needed
                Response.Headers.Set("X-Frame-Options", "DENY");
                Response.Headers.Set("X-Content-Type-Options", "nosniff");
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string username = TextBox1.Text.Trim();
            string password = TextBox2.Text;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ErrorPanel.Visible = true;
                ErrorMessageLabel.Text = "Please enter both User ID and Password.";
                return;
            }

            try
            {
                // 1. Check Admin Account
                string adminQuery = "SELECT * FROM a_login WHERE a_id = @Username AND a_password = @Password";
                SqlParameter[] adminParams = new SqlParameter[]
                {
                    new SqlParameter("@Username", SqlDbType.VarChar, 50) { Value = username },
                    new SqlParameter("@Password", SqlDbType.VarChar, 50) { Value = password }
                };
                DataSet dsAdmin = dc.GetDataSet(adminQuery, adminParams);

                if (dsAdmin.Tables[0].Rows.Count > 0)
                {
                    Session["admin"] = username;
                    Response.Redirect("dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // 2. Check Customer Account
                string custQuery = "SELECT * FROM NewCustomer WHERE Id = @Username AND password = @Password";
                SqlParameter[] custParams = new SqlParameter[]
                {
                    new SqlParameter("@Username", SqlDbType.VarChar, 50) { Value = username },
                    new SqlParameter("@Password", SqlDbType.VarChar, 50) { Value = password }
                };
                DataSet dsCust = dc.GetDataSet(custQuery, custParams);

                if (dsCust.Tables[0].Rows.Count > 0)
                {
                    string status = dsCust.Tables[0].Rows[0]["status"].ToString();
                    if (status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                    {
                        Session["cid"] = dsCust.Tables[0].Rows[0]["Id"].ToString();
                        Session["customer_name"] = dsCust.Tables[0].Rows[0]["name"].ToString();
                        Response.Redirect("c_profile.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                        return;
                    }
                    else
                    {
                        ErrorPanel.Visible = true;
                        ErrorMessageLabel.Text = "Your account is currently inactive. Contact Admin.";
                        return;
                    }
                }

                // 3. Check Supplier Account
                string suppQuery = "SELECT * FROM NewSupplier WHERE supplierid = @Username AND password = @Password";
                SqlParameter[] suppParams = new SqlParameter[]
                {
                    new SqlParameter("@Username", SqlDbType.VarChar, 50) { Value = username },
                    new SqlParameter("@Password", SqlDbType.VarChar, 50) { Value = password }
                };
                DataSet dsSupp = dc.GetDataSet(suppQuery, suppParams);

                if (dsSupp.Tables[0].Rows.Count > 0)
                {
                    string status = dsSupp.Tables[0].Rows[0]["supplierstatus"].ToString();
                    if (status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                    {
                        Session["sid"] = dsSupp.Tables[0].Rows[0]["supplierid"].ToString();
                        Session["supplier_name"] = dsSupp.Tables[0].Rows[0]["suppliername"].ToString();
                        Response.Redirect("s_profile.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                        return;
                    }
                    else
                    {
                        ErrorPanel.Visible = true;
                        ErrorMessageLabel.Text = "Your account is currently inactive. Contact Admin.";
                        return;
                    }
                }

                // Invalid Login Attempt
                ErrorPanel.Visible = true;
                ErrorMessageLabel.Text = "Invalid User ID or Password.";
            }
            catch (Exception ex)
            {
                ErrorPanel.Visible = true;
                ErrorMessageLabel.Text = "An error occurred during authentication: " + ex.Message;
            }
        }
    }
}