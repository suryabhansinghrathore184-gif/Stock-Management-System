using System;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class Site3 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Centralized Supplier Authentication Check
            if (Session["sid"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }
    }
}