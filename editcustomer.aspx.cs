using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class editcustomer : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (string.IsNullOrEmpty(id))
                {
                    Response.Redirect("customerlist.aspx");
                    return;
                }
                LoadCustomer(id);
            }
        }

        private void LoadCustomer(string id)
        {
            try
            {
                string query = "SELECT * FROM NewCustomer WHERE Id = @Id";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                DataSet ds = dc.GetDataSet(query, param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    TxtId.Text = row["Id"].ToString();
                    TxtName.Text = row["name"].ToString();
                    TxtPhone.Text = row["number"].ToString();
                    TxtAltMobile.Text = row["altmobile"].ToString();
                    TxtEmail.Text = row["email"].ToString();
                    TxtCompany.Text = row["companyname"].ToString();
                    TxtAddress.Text = row["address"].ToString();
                    
                    try { DdlCity.SelectedValue = row["city"].ToString(); } catch { }
                    
                    TxtState.Text = row["state"].ToString();
                    TxtPostalCode.Text = row["postalcode"].ToString();
                    TxtCountry.Text = string.IsNullOrEmpty(row["country"].ToString()) ? "India" : row["country"].ToString();
                    TxtGst.Text = row["gstnumber"].ToString();
                    
                    try { DdlType.SelectedValue = row["customertype"].ToString(); } catch { }
                    
                    TxtCredit.Text = Convert.ToDecimal(row["creditlimit"]).ToString("0.00");
                    
                    try { DdlStatus.SelectedValue = row["status"].ToString(); } catch { }
                    
                    TxtPassword.Text = row["password"].ToString();

                    string photo = row["customerphoto"].ToString();
                    if (!string.IsNullOrEmpty(photo))
                    {
                        ImgPreview.ImageUrl = "/Links/" + photo;
                    }
                    else
                    {
                        ImgPreview.ImageUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=80&q=80";
                    }
                }
                else
                {
                    Response.Redirect("customerlist.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading customer details: " + ex.Message);
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string id = TxtId.Text.Trim();
            string name = TxtName.Text.Trim();
            string phone = TxtPhone.Text.Trim();
            string altmobile = TxtAltMobile.Text.Trim();
            string email = TxtEmail.Text.Trim();
            string companyname = TxtCompany.Text.Trim();
            string address = TxtAddress.Text.Trim();
            string city = DdlCity.SelectedValue;
            string state = TxtState.Text.Trim();
            string postalcode = TxtPostalCode.Text.Trim();
            string country = TxtCountry.Text.Trim();
            string gstin = TxtGst.Text.Trim();
            string type = DdlType.SelectedValue;
            decimal creditLimit = 0;
            string status = DdlStatus.SelectedValue;
            string password = TxtPassword.Text.Trim();
            string photoFilename = "";

            decimal.TryParse(TxtCredit.Text, out creditLimit);

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(state) || string.IsNullOrEmpty(postalcode) || string.IsNullOrEmpty(password))
            {
                ShowAlert("Please fill in all required fields.");
                return;
            }

            try
            {
                // Check if email already exists for another customer
                string checkEmail = "SELECT COUNT(*) FROM NewCustomer WHERE email = @Email AND Id <> @Id";
                SqlParameter[] emailParam = new SqlParameter[]
                {
                    new SqlParameter("@Email", SqlDbType.VarChar) { Value = email },
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };
                if (Convert.ToInt32(dc.ExecuteScalar(checkEmail, emailParam)) > 0)
                {
                    ShowAlert("A customer profile with this email address already exists.");
                    return;
                }

                // Check if mobile number already exists for another customer
                string checkMobile = "SELECT COUNT(*) FROM NewCustomer WHERE number = @Phone AND Id <> @Id";
                SqlParameter[] mobileParam = new SqlParameter[]
                {
                    new SqlParameter("@Phone", SqlDbType.VarChar) { Value = phone },
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };
                if (Convert.ToInt32(dc.ExecuteScalar(checkMobile, mobileParam)) > 0)
                {
                    ShowAlert("A customer profile with this mobile number already exists.");
                    return;
                }

                // File Upload
                if (FileUpload1.HasFile)
                {
                    string ext = Path.GetExtension(FileUpload1.FileName).ToLower();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
                    {
                        ShowAlert("Only image files (.jpg, .png, .webp) are allowed.");
                        return;
                    }

                    if (FileUpload1.PostedFile.ContentLength > 5242880) // 5MB Limit
                    {
                        ShowAlert("Image file size must be under 5MB.");
                        return;
                    }

                    string dir = Server.MapPath("~/Links/");
                    if (!Directory.Exists(dir))
                    {
                        Directory.CreateDirectory(dir);
                    }

                    photoFilename = id + "_" + Path.GetFileName(FileUpload1.FileName);
                    FileUpload1.SaveAs(Path.Combine(dir, photoFilename));
                }

                // Update query
                string updateQuery = @"UPDATE NewCustomer 
                                       SET name = @Name, number = @Phone, email = @Email, address = @Address, city = @City, 
                                           gstnumber = @Gstin, customertype = @Type, creditlimit = @CreditLimit, status = @Status, password = @Password,
                                           altmobile = @AltMobile, companyname = @CompanyName, state = @State, postalcode = @PostalCode, country = @Country,
                                           customerphoto = CASE WHEN @Photo <> '' THEN @Photo ELSE customerphoto END
                                       WHERE Id = @Id";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id },
                    new SqlParameter("@Name", SqlDbType.VarChar) { Value = name },
                    new SqlParameter("@Phone", SqlDbType.VarChar) { Value = phone },
                    new SqlParameter("@Email", SqlDbType.VarChar) { Value = email },
                    new SqlParameter("@Address", SqlDbType.VarChar) { Value = address },
                    new SqlParameter("@City", SqlDbType.VarChar) { Value = city },
                    new SqlParameter("@Gstin", SqlDbType.VarChar) { Value = gstin },
                    new SqlParameter("@Type", SqlDbType.VarChar) { Value = type },
                    new SqlParameter("@CreditLimit", SqlDbType.Decimal) { Value = creditLimit },
                    new SqlParameter("@Status", SqlDbType.VarChar) { Value = status },
                    new SqlParameter("@Password", SqlDbType.VarChar) { Value = password },
                    new SqlParameter("@AltMobile", SqlDbType.VarChar) { Value = altmobile },
                    new SqlParameter("@CompanyName", SqlDbType.VarChar) { Value = companyname },
                    new SqlParameter("@State", SqlDbType.VarChar) { Value = state },
                    new SqlParameter("@PostalCode", SqlDbType.VarChar) { Value = postalcode },
                    new SqlParameter("@Country", SqlDbType.VarChar) { Value = country },
                    new SqlParameter("@Photo", SqlDbType.VarChar) { Value = photoFilename }
                };

                dc.ExecuteNonQuery(updateQuery, parameters);

                string alertScript = "Swal.fire('Success!', 'Customer profile updated.', 'success').then(() => { window.location.href = 'customerlist.aspx'; });";
                ScriptManager.RegisterStartupScript(this, GetType(), "redirect", alertScript, true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating customer: " + ex.Message);
            }
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }
    }
}
