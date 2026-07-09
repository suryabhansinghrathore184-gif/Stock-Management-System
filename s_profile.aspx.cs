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
                    Image1.ImageUrl = string.IsNullOrEmpty(row[0].ToString()) ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80" : "/Links/" + row[0].ToString();

                    Label1.Text = row[1].ToString();
                    Label2.Text = row[2].ToString();
                    Label3.Text = row[3].ToString();
                    Label4.Text = row[4].ToString();
                    Label5.Text = row[5].ToString();
                    Label6.Text = row[6].ToString();
                    Label7.Text = row[7].ToString();
                    Label8.Text = row[8].ToString();
                    Label9.Text = row[9].ToString();
                    Label10.Text = row[10].ToString();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading profile: " + ex.Message + "')</script>");
            }
        }
    }
}