using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class Site2 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCustomerProfile();
            }
        }

        private void LoadCustomerProfile()
        {
            try
            {
                DataCon dc = new DataCon();
                string query = "SELECT customerphoto FROM NewCustomer WHERE Id = @Id";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = Session["cid"] }
                };
                DataSet ds = dc.GetDataSet(query, param);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string photo = ds.Tables[0].Rows[0]["customerphoto"].ToString();
                    ImgProfile.ImageUrl = string.IsNullOrEmpty(photo) ? "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80" : "/Links/" + photo;
                }
                else
                {
                    ImgProfile.ImageUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80";
                }
            }
            catch
            {
                ImgProfile.ImageUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80";
            }
        }
    }
}