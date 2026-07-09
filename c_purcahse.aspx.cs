using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

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

            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid(string search = "")
        {
            string cid = Session["cid"].ToString();

            try
            {
                string query = @"SELECT s.CustomerId, p.ProductName, s.Quantity, s.Total, s.SaleDate, s.InvoiceNumber
                                 FROM Sales s 
                                 INNER JOIN Products p ON s.ProductCode = p.ProductCode 
                                 WHERE s.CustomerId = @CustomerId";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (s.InvoiceNumber LIKE @Search OR p.ProductName LIKE @Search)";
                }

                query += " ORDER BY s.SaleDate DESC";

                SqlParameter[] parameters;
                if (!string.IsNullOrEmpty(search))
                {
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@CustomerId", SqlDbType.VarChar) { Value = cid },
                        new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" }
                    };
                }
                else
                {
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@CustomerId", SqlDbType.VarChar) { Value = cid }
                    };
                }

                DataSet ds = dc.GetDataSet(query, parameters);

                // Load latest order summary only on initial load without search filters
                if (string.IsNullOrEmpty(search) && ds.Tables[0].Rows.Count > 0)
                {
                    LatestOrderPanel.Visible = true;
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
                else if (!string.IsNullOrEmpty(search))
                {
                    LatestOrderPanel.Visible = false; // Hide summary during search
                }
                else
                {
                    LatestOrderPanel.Visible = false;
                }

                GridView1.DataSource = ds.Tables[0];
                GridView1.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error loading purchases: " + ex.Message + "')</script>");
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            string term = TxtSearch.Text.Trim();
            BindGrid(term);
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            TxtSearch.Text = "";
            BindGrid();
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            BindGrid(TxtSearch.Text.Trim());
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}