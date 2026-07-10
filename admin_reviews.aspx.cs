using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class admin_reviews : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReviews();
            }
        }

        private void LoadReviews(string search = "", string rating = "")
        {
            try
            {
                string query = @"SELECT r.ReviewId, r.CustomerId, r.Rating, r.ReviewText, r.CreatedDate, p.ProductName 
                                 FROM ProductReviews r 
                                 INNER JOIN Products p ON r.ProductCode = p.ProductCode 
                                 WHERE 1=1";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (p.ProductName LIKE @Search OR r.CustomerId LIKE @Search)";
                }

                if (!string.IsNullOrEmpty(rating))
                {
                    query += " AND r.Rating = @Rating";
                }

                query += " ORDER BY r.CreatedDate DESC";

                SqlParameter[] parameters;
                if (!string.IsNullOrEmpty(search) && !string.IsNullOrEmpty(rating))
                {
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Search", "%" + search + "%"),
                        new SqlParameter("@Rating", Convert.ToInt32(rating))
                    };
                }
                else if (!string.IsNullOrEmpty(search))
                {
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Search", "%" + search + "%")
                    };
                }
                else if (!string.IsNullOrEmpty(rating))
                {
                    parameters = new SqlParameter[]
                    {
                        new SqlParameter("@Rating", Convert.ToInt32(rating))
                    };
                }
                else
                {
                    parameters = new SqlParameter[0];
                }

                DataSet ds = dc.GetDataSet(query, parameters);
                GvReviews.DataSource = ds.Tables[0];
                GvReviews.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading reviews: " + ex.Message);
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            LoadReviews(TxtSearch.Text.Trim(), DdlRatingFilter.SelectedValue);
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            TxtSearch.Text = "";
            DdlRatingFilter.SelectedIndex = 0;
            LoadReviews();
        }

        protected void GvReviews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int reviewId = Convert.ToInt32(GvReviews.DataKeys[e.RowIndex].Value);
            try
            {
                string query = "DELETE FROM ProductReviews WHERE ReviewId = @Id";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@Id", reviewId) };
                dc.ExecuteNonQuery(query, param);

                ShowAlert("Review moderated and deleted successfully.");
                LoadReviews(TxtSearch.Text.Trim(), DdlRatingFilter.SelectedValue);
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message);
            }
        }

        protected void GvReviews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GvReviews.PageIndex = e.NewPageIndex;
            LoadReviews(TxtSearch.Text.Trim(), DdlRatingFilter.SelectedValue);
        }

        public string GetStars(object ratingObj)
        {
            if (ratingObj == null || ratingObj == DBNull.Value) return "";
            int rating = Convert.ToInt32(ratingObj);
            string stars = "";
            for (int i = 0; i < rating; i++) stars += "★";
            for (int i = rating; i < 5; i++) stars += "☆";
            return stars;
        }

        private void ShowAlert(string msg)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('" + msg.Replace("'", "\\'") + "');", true);
        }
    }
}
