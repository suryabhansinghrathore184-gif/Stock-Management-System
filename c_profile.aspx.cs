using System;
using System.Data;
using System.Data.SqlClient;
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

            try
            {
                string query = "SELECT * FROM NewCustomer WHERE Id = @Id";
                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = Session["cid"] }
                };

                DataSet ds = dc.GetDataSet(query, parameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];
                    
                    string photo = row["customerphoto"].ToString();
                    Image1.ImageUrl = string.IsNullOrEmpty(photo) ? "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80" : "/Links/" + photo;

                    Label1.Text = row["Id"].ToString();
                    Label2.Text = row["name"].ToString();
                    Label3.Text = row["number"].ToString();
                    Label4.Text = row["email"].ToString();
                    Label5.Text = row["address"].ToString();
                    Label6.Text = row["city"].ToString();
                    Label7.Text = string.IsNullOrEmpty(row["gstnumber"].ToString()) ? "N/A" : row["gstnumber"].ToString();
                    Label8.Text = row["customertype"].ToString();
                    Label9.Text = Convert.ToDecimal(row["creditlimit"]).ToString("N2");
                    Label10.Text = row["status"].ToString();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading profile: " + ex.Message + "')</script>");
            }
        }
    }
}