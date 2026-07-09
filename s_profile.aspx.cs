using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm13 : System.Web.UI.Page
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
                LoadProfileData();
            }
        }

        private void LoadProfileData()
        {
            string id = Session["sid"].ToString();
            try
            {
                string query = "SELECT * FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    // Left card summaries
                    LabelNameSummary.Text = row["suppliername"].ToString();
                    LabelCompanySummary.Text = row["companyname"].ToString();
                    LabelStatusSummary.Text = row["supplierstatus"].ToString();

                    string photo = row["supplierphoto"].ToString();
                    Image1.ImageUrl = string.IsNullOrEmpty(photo) ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80" : "/Links/" + photo;

                    // Tab 1 details
                    Label1.Text = row["supplierid"].ToString();
                    Label4.Text = string.IsNullOrEmpty(row["contactperson"].ToString()) ? "-" : row["contactperson"].ToString();
                    Label5.Text = row["phonenumber"].ToString();
                    Label6.Text = row["email"].ToString();
                    Label7.Text = row["address"].ToString();
                    Label8.Text = row["city"].ToString();
                    Label9.Text = string.IsNullOrEmpty(row["gstnumber"].ToString()) ? "N/A" : row["gstnumber"].ToString();
                    LabelBankAcc.Text = string.IsNullOrEmpty(row["bank_account"].ToString()) ? "Not Configured" : row["bank_account"].ToString();
                    LabelBankName.Text = string.IsNullOrEmpty(row["bank_name"].ToString()) ? "Not Configured" : row["bank_name"].ToString();

                    // Tab 2 form values
                    TxtName.Text = row["suppliername"].ToString();
                    TxtCompany.Text = row["companyname"].ToString();
                    TxtContact.Text = row["contactperson"].ToString();
                    TxtPhone.Text = row["phonenumber"].ToString();
                    TxtEmail.Text = row["email"].ToString();
                    TxtCity.Text = row["city"].ToString();
                    TxtAddress.Text = row["address"].ToString();

                    // Tab 3 form values
                    TxtBankName.Text = row["bank_name"].ToString();
                    TxtBankAcc.Text = row["bank_account"].ToString();
                    TxtBankIfsc.Text = row["bank_ifsc"].ToString();
                    TxtGst.Text = row["gstnumber"].ToString();
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading profile details: " + ex.Message);
            }
        }

        protected void BtnUpdateProfile_Click(object sender, EventArgs e)
        {
            string id = Session["sid"].ToString();
            string name = TxtName.Text.Trim();
            string company = TxtCompany.Text.Trim();
            string contact = TxtContact.Text.Trim();
            string phone = TxtPhone.Text.Trim();
            string email = TxtEmail.Text.Trim();
            string city = TxtCity.Text.Trim();
            string address = TxtAddress.Text.Trim();
            string logoFilename = "";

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(company) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(address))
            {
                ShowAlert("Please fill in all required fields.");
                return;
            }

            try
            {
                // File Upload
                if (FuLogo.HasFile)
                {
                    string ext = Path.GetExtension(FuLogo.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
                    {
                        ShowAlert("Only image files (.jpg, .png, .webp) are allowed.");
                        return;
                    }

                    if (FuLogo.PostedFile.ContentLength > 5242880) // 5MB limit
                    {
                        ShowAlert("Logo file size must be under 5MB.");
                        return;
                    }

                    string dir = Server.MapPath("~/Links/");
                    if (!Directory.Exists(dir))
                    {
                        Directory.CreateDirectory(dir);
                    }

                    logoFilename = id + "_logo_" + Path.GetFileName(FuLogo.FileName);
                    FuLogo.SaveAs(Path.Combine(dir, logoFilename));
                }

                string updateQuery = "";
                SqlParameter[] parameters;

                if (!string.IsNullOrEmpty(logoFilename))
                {
                    updateQuery = @"UPDATE NewSupplier 
                                   SET suppliername = @Name, companyname = @Company, contactperson = @Contact, 
                                       phonenumber = @Phone, email = @Email, city = @City, address = @Address, supplierphoto = @Photo
                                   WHERE supplierid = @Id";
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Company", company),
                        new SqlParameter("@Contact", contact),
                        new SqlParameter("@Phone", phone),
                        new SqlParameter("@Email", email),
                        new SqlParameter("@City", city),
                        new SqlParameter("@Address", address),
                        new SqlParameter("@Photo", logoFilename),
                        new SqlParameter("@Id", id)
                    };
                }
                else
                {
                    updateQuery = @"UPDATE NewSupplier 
                                   SET suppliername = @Name, companyname = @Company, contactperson = @Contact, 
                                       phonenumber = @Phone, email = @Email, city = @City, address = @Address
                                   WHERE supplierid = @Id";
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Company", company),
                        new SqlParameter("@Contact", contact),
                        new SqlParameter("@Phone", phone),
                        new SqlParameter("@Email", email),
                        new SqlParameter("@City", city),
                        new SqlParameter("@Address", address),
                        new SqlParameter("@Id", id)
                    };
                }

                dc.ExecuteNonQuery(updateQuery, parameters);
                ShowAlert("Profile details updated successfully!");
                LoadProfileData();
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating profile: " + ex.Message);
            }
        }

        protected void BtnSaveBankInfo_Click(object sender, EventArgs e)
        {
            string id = Session["sid"].ToString();
            string bankName = TxtBankName.Text.Trim();
            string bankAcc = TxtBankAcc.Text.Trim();
            string bankIfsc = TxtBankIfsc.Text.Trim();
            string gst = TxtGst.Text.Trim();

            if (string.IsNullOrEmpty(bankName) || string.IsNullOrEmpty(bankAcc) || string.IsNullOrEmpty(bankIfsc) || string.IsNullOrEmpty(gst))
            {
                ShowAlert("Please fill in all Bank and GST fields.");
                return;
            }

            try
            {
                string query = @"UPDATE NewSupplier 
                                 SET bank_name = @BankName, bank_account = @BankAcc, bank_ifsc = @BankIfsc, gstnumber = @GST
                                 WHERE supplierid = @Id";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@BankName", bankName),
                    new SqlParameter("@BankAcc", bankAcc),
                    new SqlParameter("@BankIfsc", bankIfsc),
                    new SqlParameter("@GST", gst),
                    new SqlParameter("@Id", id)
                };
                dc.ExecuteNonQuery(query, parameters);
                ShowAlert("Bank and GST information saved successfully!");
                LoadProfileData();
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating bank details: " + ex.Message);
            }
        }

        protected void BtnChangePassword_Click(object sender, EventArgs e)
        {
            string id = Session["sid"].ToString();
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
                string verifyQuery = "SELECT password FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] verifyParam = new SqlParameter[] { new SqlParameter("@Id", id) };
                object dbPwd = dc.ExecuteScalar(verifyQuery, verifyParam);

                if (dbPwd == null || dbPwd.ToString() != currPwd)
                {
                    ShowAlert("Current password is incorrect.");
                    return;
                }

                // Update password
                string updateQuery = "UPDATE NewSupplier SET password = @Password WHERE supplierid = @Id";
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
                ShowAlert("Error changing password: " + ex.Message);
            }
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}