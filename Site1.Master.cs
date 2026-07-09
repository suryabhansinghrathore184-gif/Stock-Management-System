using System;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Centralized Admin Authentication Check
            if (Session["admin"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }
    }
}