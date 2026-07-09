using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace StockMangementSystem
{
    public partial class WebForm16 : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["sid"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            string sid = Session["sid"].ToString();

            try
            {
                string query = @"SELECT p.SupplierId, prod.ProductName, p.Quantity, p.PurchasePrice, p.PurchaseDate 
                                 FROM Purchases p 
                                 INNER JOIN Products prod ON p.ProductCode = prod.ProductCode 
                                 WHERE p.SupplierId = @SupplierId 
                                 ORDER BY p.PurchaseDate DESC";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@SupplierId", SqlDbType.VarChar) { Value = sid }
                };

                DataSet ds = dc.GetDataSet(query, parameters);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    Label1.Text = ds.Tables[0].Rows[0]["SupplierId"].ToString();
                    Label2.Text = ds.Tables[0].Rows[0]["ProductName"].ToString();
                    Label3.Text = ds.Tables[0].Rows[0]["Quantity"].ToString();
                    Label4.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["PurchasePrice"]).ToString("N2");
                    
                    DateTime date;
                    if (DateTime.TryParse(ds.Tables[0].Rows[0]["PurchaseDate"].ToString(), out date))
                    {
                        Label5.Text = date.ToString("dd-MM-yyyy HH:mm");
                    }
                    else
                    {
                        Label5.Text = ds.Tables[0].Rows[0]["PurchaseDate"].ToString();
                    }
                }

                GridView1.DataSource = ds.Tables[0];
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading supplies: " + ex.Message + "')</script>");
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}