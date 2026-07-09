using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm12 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            string cid = Session["cid"].ToString();

            try
            {
                string query = @"SELECT s.CustomerId, p.ProductName, s.Quantity, s.Total, s.SaleDate 
                                 FROM Sales s 
                                 INNER JOIN Products p ON s.ProductCode = p.ProductCode 
                                 WHERE s.CustomerId = @CustomerId 
                                 ORDER BY s.SaleDate DESC";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@CustomerId", SqlDbType.VarChar) { Value = cid }
                };

                DataSet ds = dc.GetDataSet(query, parameters);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    Label1.Text = ds.Tables[0].Rows[0]["CustomerId"].ToString();
                    Label2.Text = ds.Tables[0].Rows[0]["ProductName"].ToString();
                    Label3.Text = ds.Tables[0].Rows[0]["Quantity"].ToString();
                    Label4.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["Total"]).ToString("N2");
                    
                    DateTime date;
                    if (DateTime.TryParse(ds.Tables[0].Rows[0]["SaleDate"].ToString(), out date))
                    {
                        Label6.Text = date.ToString("dd-MM-yyyy HH:mm");
                    }
                    else
                    {
                        Label6.Text = ds.Tables[0].Rows[0]["SaleDate"].ToString();
                    }
                }

                GridView1.DataSource = ds.Tables[0];
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading purchases: " + ex.Message + "')</script>");
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}