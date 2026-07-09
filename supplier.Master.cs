using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class Site3 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["sid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSupplierProfile();
            }
        }

        private void LoadSupplierProfile()
        {
            try
            {
                DataCon dc = new DataCon();
                string query = "SELECT supplierphoto FROM NewSupplier WHERE supplierid = @Id";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Id", SqlDbType.VarChar) { Value = Session["sid"] }
                };
                DataSet ds = dc.GetDataSet(query, param);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string photo = ds.Tables[0].Rows[0]["supplierphoto"].ToString();
                    ImgProfile.ImageUrl = string.IsNullOrEmpty(photo) ? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80" : "/Links/" + photo;
                }
                else
                {
                    ImgProfile.ImageUrl = "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80";
                }
            }
            catch
            {
                ImgProfile.ImageUrl = "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80";
            }
        }
    }
}