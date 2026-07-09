using System;
using System.Web;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class Site2 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Centralized Customer Authentication Check
            if (Session["cid"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }
    }
}