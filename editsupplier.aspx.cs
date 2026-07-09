using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class editsupplier : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (string.IsNullOrEmpty(id))
                {
                    Response.Redirect("supplierlist.aspx");
                    return;
                }
                LoadSupplier(id);
            }
        }

        private void LoadSupplier(string id)
        {
            try
            {
                string query = "SELECT * FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", SqlDbType.VarChar) { Value = id } };
                DataSet ds = dc.GetDataSet(query, param);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    TxtId.Text = row["supplierid"].ToString();
                    TxtName.Text = row["suppliername"].ToString();
                    TxtCompany.Text = row["companyname"].ToString();
                    TxtContact.Text = row["contactperson"].ToString();
                    TxtPhone.Text = row["phonenumber"].ToString();
                    TxtAltPhone.Text = row["altnumber"].ToString();
                    TxtEmail.Text = row["email"].ToString();
                    TxtWebsite.Text = row["website"].ToString();
                    TxtAddress.Text = row["address"].ToString();
                    TxtCity.Text = row["city"].ToString();
                    TxtState.Text = row["state"].ToString();
                    TxtPostalCode.Text = row["postalcode"].ToString();
                    TxtCountry.Text = string.IsNullOrEmpty(row["country"].ToString()) ? "India" : row["country"].ToString();
                    TxtGst.Text = row["gstnumber"].ToString();
                    TxtPan.Text = row["pannumber"].ToString();
                    
                    try { DdlStatus.SelectedValue = row["supplierstatus"].ToString(); } catch { }
                    
                    TxtPassword.Text = row["password"].ToString();
                    TxtBank.Text = row["bankdetails"].ToString();

                    string photo = row["supplierphoto"].ToString();
                    if (!string.IsNullOrEmpty(photo))
                    {
                        ImgPreview.ImageUrl = "/Links/" + photo;
                    }
                    else
                    {
                        ImgPreview.ImageUrl = "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=80&q=80";
                    }
                }
                else
                {
                    Response.Redirect("supplierlist.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading supplier details: " + ex.Message);
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            string id = TxtId.Text.Trim();
            string name = TxtName.Text.Trim();
            string company = TxtCompany.Text.Trim();
            string contact = TxtContact.Text.Trim();
            string phone = TxtPhone.Text.Trim();
            string altnumber = TxtAltPhone.Text.Trim();
            string email = TxtEmail.Text.Trim();
            string website = TxtWebsite.Text.Trim();
            string address = TxtAddress.Text.Trim();
            string city = TxtCity.Text.Trim();
            string state = TxtState.Text.Trim();
            string postalcode = TxtPostalCode.Text.Trim();
            string country = TxtCountry.Text.Trim();
            string gstin = TxtGst.Text.Trim();
            string pannumber = TxtPan.Text.Trim();
            string status = DdlStatus.SelectedValue;
            string password = TxtPassword.Text.Trim();
            string bankdetails = TxtBank.Text.Trim();
            string photoFilename = "";

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(company) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(state) || string.IsNullOrEmpty(postalcode) || string.IsNullOrEmpty(password))
            {
                ShowAlert("Please fill in all required fields.");
                return;
            }

            try
            {
                // Check duplicate email
                string checkEmail = "SELECT COUNT(*) FROM NewSupplier WHERE email = @Email AND supplierid <> @Id";
                SqlParameter[] emailParam = new SqlParameter[]
                {
                    new SqlParameter("@Email", SqlDbType.VarChar) { Value = email },
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };
                if (Convert.ToInt32(dc.ExecuteScalar(checkEmail, emailParam)) > 0)
                {
                    ShowAlert("A supplier profile with this email address already exists.");
                    return;
                }

                // Check duplicate mobile
                string checkPhone = "SELECT COUNT(*) FROM NewSupplier WHERE phonenumber = @Phone AND supplierid <> @Id";
                SqlParameter[] phoneParam = new SqlParameter[]
                {
                    new SqlParameter("@Phone", SqlDbType.VarChar) { Value = phone },
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id }
                };
                if (Convert.ToInt32(dc.ExecuteScalar(checkPhone, phoneParam)) > 0)
                {
                    ShowAlert("A supplier profile with this mobile number already exists.");
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
                string updateQuery = @"UPDATE NewSupplier 
                                       SET suppliername = @Name, companyname = @Company, contactperson = @Contact, phonenumber = @Phone, email = @Email, 
                                           website = @Website, address = @Address, city = @City, state = @State, postalcode = @PostalCode, country = @Country, 
                                           gstnumber = @Gstin, pannumber = @Pan, supplierstatus = @Status, password = @Password, bankdetails = @Bank,
                                           supplierphoto = CASE WHEN @Photo <> '' THEN @Photo ELSE supplierphoto END
                                       WHERE supplierid = @Id";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id },
                    new SqlParameter("@Name", SqlDbType.VarChar) { Value = name },
                    new SqlParameter("@Company", SqlDbType.VarChar) { Value = company },
                    new SqlParameter("@Contact", SqlDbType.VarChar) { Value = contact },
                    new SqlParameter("@Phone", SqlDbType.VarChar) { Value = phone },
                    new SqlParameter("@Email", SqlDbType.VarChar) { Value = email },
                    new SqlParameter("@Website", SqlDbType.VarChar) { Value = website },
                    new SqlParameter("@Address", SqlDbType.VarChar) { Value = address },
                    new SqlParameter("@City", SqlDbType.VarChar) { Value = city },
                    new SqlParameter("@State", SqlDbType.VarChar) { Value = state },
                    new SqlParameter("@PostalCode", SqlDbType.VarChar) { Value = postalcode },
                    new SqlParameter("@Country", SqlDbType.VarChar) { Value = country },
                    new SqlParameter("@Gstin", SqlDbType.VarChar) { Value = gstin },
                    new SqlParameter("@Pan", SqlDbType.VarChar) { Value = pannumber },
                    new SqlParameter("@Status", SqlDbType.VarChar) { Value = status },
                    new SqlParameter("@Password", SqlDbType.VarChar) { Value = password },
                    new SqlParameter("@Bank", SqlDbType.VarChar) { Value = bankdetails },
                    new SqlParameter("@Photo", SqlDbType.VarChar) { Value = photoFilename }
                };

                dc.ExecuteNonQuery(updateQuery, parameters);

                string alertScript = "Swal.fire('Success!', 'Supplier profile updated successfully.', 'success').then(() => { window.location.href = 'supplierlist.aspx'; });";
                ScriptManager.RegisterStartupScript(this, GetType(), "redirect", alertScript, true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating supplier: " + ex.Message);
            }
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }
    }
}
