using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenerateNextCustomerId();
            }
        }

        private void GenerateNextCustomerId()
        {
            try
            {
                object maxIdObj = dc.ExecuteScalar("SELECT MAX(CAST(Id AS INT)) FROM NewCustomer");
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
            string phone = TextBox3.Text.Trim();
            string altmobile = TxtAltMobile.Text.Trim();
            string email = TextBox4.Text.Trim();
            string companyname = TxtCompany.Text.Trim();
            string address = TextBox5.Text.Trim();
            string city = DropDownList1.SelectedValue;
            string state = TxtState.Text.Trim();
            string postalcode = TxtPostalCode.Text.Trim();
            string country = TxtCountry.Text.Trim();
            string gstin = TextBox6.Text.Trim();
            string type = DropDownList2.SelectedValue;
            decimal creditLimit = 0;
            string status = DropDownList3.SelectedValue;
            string password = TextBox8.Text.Trim();
            string photoFilename = "";

            decimal.TryParse(TextBox7.Text, out creditLimit);

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(state) || string.IsNullOrEmpty(postalcode) || string.IsNullOrEmpty(password))
            {
                ShowAlert("Please fill in all required fields.");
                return;
            }

            try
            {
                // Check if email already exists
                string checkEmail = "SELECT COUNT(*) FROM NewCustomer WHERE email = @Email";
                SqlParameter[] emailParam = new SqlParameter[] { new SqlParameter("@Email", SqlDbType.VarChar) { Value = email } };
                if (Convert.ToInt32(dc.ExecuteScalar(checkEmail, emailParam)) > 0)
                {
                    ShowAlert("A customer profile with this email address already exists.");
                    return;
                }

                // Check if mobile number already exists
                string checkMobile = "SELECT COUNT(*) FROM NewCustomer WHERE number = @Phone";
                SqlParameter[] mobileParam = new SqlParameter[] { new SqlParameter("@Phone", SqlDbType.VarChar) { Value = phone } };
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

                // Insert query with new columns
                string insertQuery = @"INSERT INTO NewCustomer (photolink, Id, name, number, email, address, city, gstnumber, customertype, creditlimit, status, password, altmobile, companyname, state, postalcode, country, createddate)
                                       VALUES (@Photo, @Id, @Name, @Phone, @Email, @Address, @City, @Gstin, @Type, @CreditLimit, @Status, @Password, @AltMobile, @CompanyName, @State, @PostalCode, @Country, GETDATE())";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Photo", SqlDbType.VarChar) { Value = photoFilename },
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
                    new SqlParameter("@Country", SqlDbType.VarChar) { Value = country }
                };

                dc.ExecuteNonQuery(insertQuery, parameters);

                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "Swal.fire('Success!', 'Customer registered successfully.', 'success');", true);
                ResetForm();
                GenerateNextCustomerId();
            }
            catch (Exception ex)
            {
                ShowAlert("Error registering customer: " + ex.Message);
            }
        }

        private void ResetForm()
        {
            TextBox2.Text = "";
            TextBox3.Text = "";
            TxtAltMobile.Text = "";
            TextBox4.Text = "";
            TxtCompany.Text = "";
            TextBox5.Text = "";
            TextBox6.Text = "";
            TextBox7.Text = "1000.00";
            TextBox8.Text = "";
            TxtState.Text = "";
            TxtPostalCode.Text = "";
            TxtCountry.Text = "India";
            DropDownList1.SelectedIndex = 0;
            DropDownList2.SelectedIndex = 0;
            DropDownList3.SelectedIndex = 0;
            AlertPanel.Visible = false;
        }

        private void ShowAlert(string message)
        {
            AlertPanel.Visible = true;
            AlertMsgLabel.Text = message;
        }

        protected void TextBox7_TextChanged(object sender, EventArgs e)
        {
        }
    }
}