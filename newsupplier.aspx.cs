using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenerateNextSupplierId();
            }
        }

        private void GenerateNextSupplierId()
        {
            try
            {
                object maxIdObj = dc.ExecuteScalar("SELECT MAX(CAST(supplierid AS INT)) FROM NewSupplier");
                if (maxIdObj == null || maxIdObj == DBNull.Value)
                {
                    TextBox1.Text = "101";
                }
                else
                {
                    int nextId = Convert.ToInt32(maxIdObj) + 1;
                    TextBox1.Text = nextId.ToString();
                }
            }
            catch
            {
                TextBox1.Text = "101";
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string id = TextBox1.Text.Trim();
            string name = TextBox2.Text.Trim();
            string company = TextBox3.Text.Trim();
            string contact = TextBox4.Text.Trim();
            string phone = TextBox5.Text.Trim();
            string altnumber = TxtAltNumber.Text.Trim();
            string email = TextBox6.Text.Trim();
            string website = TxtWebsite.Text.Trim();
            string address = TextBox7.Text.Trim();
            string city = TextBox8.Text.Trim();
            string state = TxtState.Text.Trim();
            string postalcode = TxtPostalCode.Text.Trim();
            string country = TxtCountry.Text.Trim();
            string gstin = TextBox9.Text.Trim();
            string pannumber = TxtPanNumber.Text.Trim();
            string status = DropDownList1.SelectedValue;
            string password = TextBox10.Text.Trim();
            string bankdetails = TxtBankDetails.Text.Trim();
            string photoFilename = "";

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(company) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(state) || string.IsNullOrEmpty(postalcode) || string.IsNullOrEmpty(password))
            {
                ShowAlert("Please fill in all required fields.");
                return;
            }

            try
            {
                // Check if email already exists
                string checkEmail = "SELECT COUNT(*) FROM NewSupplier WHERE email = @Email";
                SqlParameter[] emailParam = new SqlParameter[] { new SqlParameter("@Email", SqlDbType.VarChar) { Value = email } };
                if (Convert.ToInt32(dc.ExecuteScalar(checkEmail, emailParam)) > 0)
                {
                    ShowAlert("A supplier profile with this email address already exists.");
                    return;
                }

                // Check if phone already exists
                string checkPhone = "SELECT COUNT(*) FROM NewSupplier WHERE phonenumber = @Phone";
                SqlParameter[] phoneParam = new SqlParameter[] { new SqlParameter("@Phone", SqlDbType.VarChar) { Value = phone } };
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

                // Insert query with new columns
                string insertQuery = @"INSERT INTO NewSupplier (supplierphoto, supplierid, suppliername, companyname, contactperson, phonenumber, email, address, city, gstnumber, supplierstatus, password, pannumber, altnumber, state, postalcode, country, website, bankdetails, createddate)
                                       VALUES (@Photo, @Id, @Name, @Company, @Contact, @Phone, @Email, @Address, @City, @Gstin, @Status, @Password, @Pan, @AltNumber, @State, @PostalCode, @Country, @Website, @Bank, GETDATE())";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Photo", SqlDbType.VarChar) { Value = photoFilename },
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = id },
                    new SqlParameter("@Name", SqlDbType.VarChar) { Value = name },
                    new SqlParameter("@Company", SqlDbType.VarChar) { Value = company },
                    new SqlParameter("@Contact", SqlDbType.VarChar) { Value = contact },
                    new SqlParameter("@Phone", SqlDbType.VarChar) { Value = phone },
                    new SqlParameter("@Email", SqlDbType.VarChar) { Value = email },
                    new SqlParameter("@Address", SqlDbType.VarChar) { Value = address },
                    new SqlParameter("@City", SqlDbType.VarChar) { Value = city },
                    new SqlParameter("@Gstin", SqlDbType.VarChar) { Value = gstin },
                    new SqlParameter("@Status", SqlDbType.VarChar) { Value = status },
                    new SqlParameter("@Password", SqlDbType.VarChar) { Value = password },
                    new SqlParameter("@Pan", SqlDbType.VarChar) { Value = pannumber },
                    new SqlParameter("@AltNumber", SqlDbType.VarChar) { Value = altnumber },
                    new SqlParameter("@State", SqlDbType.VarChar) { Value = state },
                    new SqlParameter("@PostalCode", SqlDbType.VarChar) { Value = postalcode },
                    new SqlParameter("@Country", SqlDbType.VarChar) { Value = country },
                    new SqlParameter("@Website", SqlDbType.VarChar) { Value = website },
                    new SqlParameter("@Bank", SqlDbType.VarChar) { Value = bankdetails }
                };

                dc.ExecuteNonQuery(insertQuery, parameters);

                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Success!', 'Supplier registered successfully.', 'success');", true);
                ResetForm();
                GenerateNextSupplierId();
            }
            catch (Exception ex)
            {
                ShowAlert("Error registering supplier: " + ex.Message);
            }
        }

        private void ResetForm()
        {
            TextBox2.Text = "";
            TextBox3.Text = "";
            TextBox4.Text = "";
            TextBox5.Text = "";
            TxtAltNumber.Text = "";
            TextBox6.Text = "";
            TxtWebsite.Text = "";
            TextBox7.Text = "";
            TextBox8.Text = "";
            TxtState.Text = "";
            TxtPostalCode.Text = "";
            TxtCountry.Text = "India";
            TextBox9.Text = "";
            TxtPanNumber.Text = "";
            TextBox10.Text = "";
            TxtBankDetails.Text = "";
            DropDownList1.SelectedIndex = 0;
            AlertPanel.Visible = false;
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}