using System;
using System.Data;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm18 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindRegistrations();
            }
        }

        private void BindRegistrations()
        {
            try
            {
                // Query unioning Admins, Customers, and Suppliers
                string query = @"
                    SELECT 'Admin' as [Role], a_id as [User ID / Name], '-' as [Mobile/Phone], '-' as [Email], 'Active' as [Status] 
                    FROM a_login
                    UNION ALL
                    SELECT 'Customer' as [Role], name as [User ID / Name], number as [Mobile/Phone], email as [Email], status as [Status] 
                    FROM NewCustomer
                    UNION ALL
                    SELECT 'Supplier' as [Role], suppliername as [User ID / Name], phonenumber as [Mobile/Phone], email as [Email], supplierstatus as [Status] 
                    FROM NewSupplier";

                DataSet ds = dc.getdata(query);
                GridView1.DataSource = ds;
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading registrations: " + ex.Message + "')</script>");
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}