using System;
using System.Data;
using System.Data.SqlClient;
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

            try
            {
                string query = "SELECT * FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = Session["sid"] }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    
                    string photo = row["supplierphoto"].ToString();
                    Image1.ImageUrl = string.IsNullOrEmpty(photo) ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80" : "/Links/" + photo;

                    Label1.Text = row["supplierid"].ToString();
                    Label2.Text = row["suppliername"].ToString();
                    Label3.Text = row["companyname"].ToString();
                    Label4.Text = string.IsNullOrEmpty(row["contactperson"].ToString()) ? "-" : row["contactperson"].ToString();
                    Label5.Text = row["phonenumber"].ToString();
                    Label6.Text = row["email"].ToString();
                    Label7.Text = row["address"].ToString();
                    Label8.Text = row["city"].ToString();
                    Label9.Text = string.IsNullOrEmpty(row["gstnumber"].ToString()) ? "N/A" : row["gstnumber"].ToString();
                    Label10.Text = row["supplierstatus"].ToString();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading profile: " + ex.Message + "')</script>");
            }
        }
    }
}