using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm15 : System.Web.UI.Page
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
                LoadProfileData();
            }
        }

        private void LoadProfileData()
        {
            string id = Session["cid"].ToString();
            try
            {
                string query = "SELECT * FROM NewCustomer WHERE Id = @Id";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    // Left card summaries
                    LabelNameSummary.Text = row["name"].ToString();
                    LabelTypeSummary.Text = row["customertype"].ToString();
                    LabelStatusSummary.Text = row["status"].ToString();

                    string photo = row["customerphoto"].ToString();
                    Image1.ImageUrl = string.IsNullOrEmpty(photo) ? "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80" : "/Links/" + photo;

                    // Tab 1 details
                    Label1.Text = row["Id"].ToString();
                    Label3.Text = row["number"].ToString();
                    Label4.Text = row["email"].ToString();
                    Label5.Text = row["address"].ToString();
                    Label6.Text = row["city"].ToString();
                    Label7.Text = string.IsNullOrEmpty(row["gstnumber"].ToString()) ? "N/A" : row["gstnumber"].ToString();
                    Label9.Text = Convert.ToDecimal(row["creditlimit"]).ToString("N2");

                    // Tab 2 form values
                    TxtName.Text = row["name"].ToString();
                    TxtPhone.Text = row["number"].ToString();
                    TxtEmail.Text = row["email"].ToString();
                    TxtCity.Text = row["city"].ToString();
                    TxtAddress.Text = row["address"].ToString();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading profile details: " + ex.Message);
            }
        }

        protected void BtnUpdateProfile_Click(object sender, EventArgs e)
        {
            string id = Session["cid"].ToString();
            string name = TxtName.Text.Trim();
            string phone = TxtPhone.Text.Trim();
            string email = TxtEmail.Text.Trim();
            string city = TxtCity.Text.Trim();
            string address = TxtAddress.Text.Trim();
            string photoFilename = "";

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(address))
            {
                ShowAlert("Please fill in all required fields.");
                return;
            }

            try
            {
                // File Upload handling
                if (FuPhoto.HasFile)
                {
                    string ext = Path.GetExtension(FuPhoto.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
                    {
                        ShowAlert("Only image files (.jpg, .png, .webp) are allowed.");
                        return;
                    }

                    if (FuPhoto.PostedFile.ContentLength > 5242880) // 5MB limit
                    {
                        ShowAlert("Profile picture size must be under 5MB.");
                        return;
                    }

                    string dir = Server.MapPath("~/Links/");
                    if (!Directory.Exists(dir))
                    {
                        Directory.CreateDirectory(dir);
                    }

                    photoFilename = id + "_profile_" + Path.GetFileName(FuPhoto.FileName);
                    FuPhoto.SaveAs(Path.Combine(dir, photoFilename));
                }

                string updateQuery = "";
                SqlParameter[] parameters;

                if (!string.IsNullOrEmpty(photoFilename))
                {
                    updateQuery = @"UPDATE NewCustomer 
                                   SET name = @Name, number = @Phone, email = @Email, city = @City, address = @Address, customerphoto = @Photo
                                   WHERE Id = @Id";
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Phone", phone),
                        new SqlParameter("@Email", email),
                        new SqlParameter("@City", city),
                        new SqlParameter("@Address", address),
                        new SqlParameter("@Photo", photoFilename),
                        new SqlParameter("@Id", id)
                    };
                }
                else
                {
                    updateQuery = @"UPDATE NewCustomer 
                                   SET name = @Name, number = @Phone, email = @Email, city = @City, address = @Address
                                   WHERE Id = @Id";
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Phone", phone),
                        new SqlParameter("@Email", email),
                        new SqlParameter("@City", city),
                        new SqlParameter("@Address", address),
                        new SqlParameter("@Id", id)
                    };
                }

                dc.ExecuteNonQuery(updateQuery, parameters);
                ShowAlert("Profile updated successfully!");
                LoadProfileData();
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating profile: " + ex.Message);
            }
        }

        protected void BtnChangePassword_Click(object sender, EventArgs e)
        {
            string id = Session["cid"].ToString();
            string currPwd = TxtCurrentPassword.Text;
            string newPwd = TxtNewPassword.Text;
            string confPwd = TxtConfirmPassword.Text;

            if (string.IsNullOrEmpty(currPwd) || string.IsNullOrEmpty(newPwd) || string.IsNullOrEmpty(confPwd))
            {
                ShowAlert("All password fields are required.");
                return;
            }

            if (newPwd != confPwd)
            {
                ShowAlert("New password and confirm password do not match.");
                return;
            }

            try
            {
                // Verify current password
                string verifyQuery = "SELECT password FROM NewCustomer WHERE Id = @Id";
                SqlParameter[] verifyParam = new SqlParameter[] { new SqlParameter("@Id", id) };
                object dbPwd = dc.ExecuteScalar(verifyQuery, verifyParam);

                if (dbPwd == null || dbPwd.ToString() != currPwd)
                {
                    ShowAlert("Current password is incorrect.");
                    return;
                }

                // Update to new password
                string updateQuery = "UPDATE NewCustomer SET password = @Password WHERE Id = @Id";
                SqlParameter[] updateParams = new SqlParameter[]
                {
                    new SqlParameter("@Password", newPwd),
                    new SqlParameter("@Id", id)
                };
                dc.ExecuteNonQuery(updateQuery, updateParams);
                ShowAlert("Password changed successfully!");
                TxtCurrentPassword.Text = "";
                TxtNewPassword.Text = "";
                TxtConfirmPassword.Text = "";
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating password: " + ex.Message);
            }
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}