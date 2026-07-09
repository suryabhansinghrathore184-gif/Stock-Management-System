using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class c_addressbook : System.Web.UI.Page
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
                LoadAddresses();
            }
        }

        private void LoadAddresses()
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = "SELECT * FROM CustomerAddresses WHERE CustomerId = @CustomerId ORDER BY IsDefaultBilling DESC, IsDefaultShipping DESC, AddressId DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@CustomerId", cid) };
                GvAddresses.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvAddresses.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading addresses: " + ex.Message);
            }
        }

        protected void BtnSaveAddress_Click(object sender, EventArgs e)
        {
            string cid = Session["cid"].ToString();
            string name = TxtContactName.Text.Trim();
            string phone = TxtPhone.Text.Trim();
            string street = TxtStreet.Text.Trim();
            string city = TxtCity.Text.Trim();
            string state = TxtState.Text.Trim();
            string postal = TxtPostal.Text.Trim();
            string country = TxtCountry.Text.Trim();
            bool billing = ChkDefaultBilling.Checked;
            bool shipping = ChkDefaultShipping.Checked;
            string addressId = HfAddressId.Value;

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(street) || string.IsNullOrEmpty(city) || string.IsNullOrEmpty(state) || string.IsNullOrEmpty(postal))
            {
                ShowAlert("Please fill in all required fields.");
                return;
            }

            try
            {
                // Reset defaults if new ones are checked
                if (billing)
                {
                    string resetBilling = "UPDATE CustomerAddresses SET IsDefaultBilling = 0 WHERE CustomerId = @CustomerId";
                    dc.ExecuteNonQuery(resetBilling, new SqlParameter[] { new SqlParameter("@CustomerId", cid) });
                }
                if (shipping)
                {
                    string resetShipping = "UPDATE CustomerAddresses SET IsDefaultShipping = 0 WHERE CustomerId = @CustomerId";
                    dc.ExecuteNonQuery(resetShipping, new SqlParameter[] { new SqlParameter("@CustomerId", cid) });
                }

                if (!string.IsNullOrEmpty(addressId))
                {
                    // Update
                    string update = @"UPDATE CustomerAddresses 
                                     SET Name = @Name, Phone = @Phone, AddressLine = @Street, City = @City, State = @State, 
                                         PostalCode = @Postal, Country = @Country, IsDefaultBilling = @Billing, IsDefaultShipping = @Shipping
                                     WHERE AddressId = @AddressId";
                    SqlParameter[] param = new SqlParameter[]
                    {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Phone", phone),
                        new SqlParameter("@Street", street),
                        new SqlParameter("@City", city),
                        new SqlParameter("@State", state),
                        new SqlParameter("@Postal", postal),
                        new SqlParameter("@Country", country),
                        new SqlParameter("@Billing", billing),
                        new SqlParameter("@Shipping", shipping),
                        new SqlParameter("@AddressId", Convert.ToInt32(addressId))
                    };
                    dc.ExecuteNonQuery(update, param);
                    ShowAlert("Address updated successfully!");
                }
                else
                {
                    // Insert
                    string insert = @"INSERT INTO CustomerAddresses (CustomerId, Name, Phone, AddressLine, City, State, PostalCode, Country, IsDefaultBilling, IsDefaultShipping) 
                                     VALUES (@CustomerId, @Name, @Phone, @Street, @City, @State, @Postal, @Country, @Billing, @Shipping)";
                    SqlParameter[] param = new SqlParameter[]
                    {
                        new SqlParameter("@CustomerId", cid),
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Phone", phone),
                        new SqlParameter("@Street", street),
                        new SqlParameter("@City", city),
                        new SqlParameter("@State", state),
                        new SqlParameter("@Postal", postal),
                        new SqlParameter("@Country", country),
                        new SqlParameter("@Billing", billing),
                        new SqlParameter("@Shipping", shipping)
                    };
                    dc.ExecuteNonQuery(insert, param);
                    ShowAlert("New address saved successfully!");
                }

                ResetForm();
                LoadAddresses();
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving address: " + ex.Message);
            }
        }

        protected void GvAddresses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditAddress")
            {
                int addressId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    string query = "SELECT * FROM CustomerAddresses WHERE AddressId = @AddressId";
                    SqlParameter[] param = new SqlParameter[] { new SqlParameter("@AddressId", addressId) };
                    DataSet ds = dc.GetDataSet(query, param);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataRow row = ds.Tables[0].Rows[0];
                        HfAddressId.Value = row["AddressId"].ToString();
                        TxtContactName.Text = row["Name"].ToString();
                        TxtPhone.Text = row["Phone"].ToString();
                        TxtStreet.Text = row["AddressLine"].ToString();
                        TxtCity.Text = row["City"].ToString();
                        TxtState.Text = row["State"].ToString();
                        TxtPostal.Text = row["PostalCode"].ToString();
                        TxtCountry.Text = row["Country"].ToString();
                        ChkDefaultBilling.Checked = Convert.ToBoolean(row["IsDefaultBilling"]);
                        ChkDefaultShipping.Checked = Convert.ToBoolean(row["IsDefaultShipping"]);

                        LblFormTitle.Text = "Edit Address";
                        BtnCancel.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error: " + ex.Message);
                }
            }
            else if (e.CommandName == "DeleteAddress")
            {
                int addressId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    string query = "DELETE FROM CustomerAddresses WHERE AddressId = @AddressId";
                    SqlParameter[] param = new SqlParameter[] { new SqlParameter("@AddressId", addressId) };
                    dc.ExecuteNonQuery(query, param);
                    ShowAlert("Address deleted successfully.");
                    LoadAddresses();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error: " + ex.Message);
                }
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            HfAddressId.Value = "";
            TxtContactName.Text = "";
            TxtPhone.Text = "";
            TxtStreet.Text = "";
            TxtCity.Text = "";
            TxtState.Text = "";
            TxtPostal.Text = "";
            TxtCountry.Text = "India";
            ChkDefaultBilling.Checked = false;
            ChkDefaultShipping.Checked = false;

            LblFormTitle.Text = "Add New Address";
            BtnCancel.Visible = false;
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}
