using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class c_feedback : System.Web.UI.Page
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
                LoadProducts();
                LoadReviews();
            }
        }

        private void LoadProducts()
        {
            try
            {
                string query = "SELECT ProductCode, ProductName FROM Products ORDER BY ProductName";
                DataSet ds = dc.GetDataSet(query);
                DdlProducts.DataSource = ds.Tables[0];
                DdlProducts.DataTextField = "ProductName";
                DdlProducts.DataValueField = "ProductCode";
                DdlProducts.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading products: " + ex.Message);
            }
        }

        private void LoadReviews()
        {
            string cid = Session["cid"].ToString();
            try
            {
                string query = @"SELECT r.ReviewId, r.Rating, r.ReviewText, p.ProductName 
                                 FROM ProductReviews r 
                                 INNER JOIN Products p ON r.ProductCode = p.ProductCode 
                                 WHERE r.CustomerId = @CustomerId 
                                 ORDER BY r.CreatedDate DESC";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@CustomerId", cid) };
                GvReviews.DataSource = dc.GetDataSet(query, param).Tables[0];
                GvReviews.DataBind();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading reviews: " + ex.Message);
            }
        }

        protected void BtnSubmitReview_Click(object sender, EventArgs e)
        {
            string cid = Session["cid"].ToString();
            string productCode = DdlProducts.SelectedValue;
            int rating = Convert.ToInt32(DdlRating.SelectedValue);
            string reviewText = TxtReviewText.Text.Trim();

            if (string.IsNullOrEmpty(reviewText))
            {
                ShowAlert("Please type some comments for the review.");
                return;
            }

            try
            {
                // Check if already reviewed this product
                string checkQuery = "SELECT COUNT(*) FROM ProductReviews WHERE CustomerId = @CustomerId AND ProductCode = @ProductCode";
                SqlParameter[] checkParam = new SqlParameter[]
                {
                    new SqlParameter("@CustomerId", cid),
                    new SqlParameter("@ProductCode", productCode)
                };
                if (Convert.ToInt32(dc.ExecuteScalar(checkQuery, checkParam)) > 0)
                {
                    ShowAlert("You have already reviewed this product. You can edit your existing review in the history table.");
                    return;
                }

                // Insert Review
                string query = "INSERT INTO ProductReviews (CustomerId, ProductCode, Rating, ReviewText, CreatedDate) VALUES (@CustomerId, @ProductCode, @Rating, @ReviewText, GETDATE())";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@CustomerId", cid),
                    new SqlParameter("@ProductCode", productCode),
                    new SqlParameter("@Rating", rating),
                    new SqlParameter("@ReviewText", reviewText)
                };
                dc.ExecuteNonQuery(query, param);

                ShowAlert("Review submitted successfully!");
                TxtReviewText.Text = "";
                LoadReviews();
            }
            catch (Exception ex)
            {
                ShowAlert("Error submitting review: " + ex.Message);
            }
        }

        protected void GvReviews_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GvReviews.EditIndex = e.NewEditIndex;
            LoadReviews();
        }

        protected void GvReviews_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GvReviews.EditIndex = -1;
            LoadReviews();
        }

        protected void GvReviews_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int reviewId = Convert.ToInt32(GvReviews.DataKeys[e.RowIndex].Value);
            
            GridViewRow row = GvReviews.Rows[e.RowIndex];
            DropDownList ddlRate = (DropDownList)row.FindControl("DdlEditRating");
            TextBox txtComment = (TextBox)row.FindControl("TxtEditReviewText");

            if (ddlRate == null || txtComment == null)
            {
                return;
            }

            int rating = Convert.ToInt32(ddlRate.SelectedValue);
            string comment = txtComment.Text.Trim();

            if (string.IsNullOrEmpty(comment))
            {
                ShowAlert("Review comments cannot be empty.");
                return;
            }

            try
            {
                string query = "UPDATE ProductReviews SET Rating = @Rating, ReviewText = @ReviewText WHERE ReviewId = @ReviewId";
                SqlParameter[] param = new SqlParameter[]
                {
                    new SqlParameter("@Rating", rating),
                    new SqlParameter("@ReviewText", comment),
                    new SqlParameter("@ReviewId", reviewId)
                };
                dc.ExecuteNonQuery(query, param);
                
                GvReviews.EditIndex = -1;
                ShowAlert("Review updated successfully!");
                LoadReviews();
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating review: " + ex.Message);
            }
        }

        protected void GvReviews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int reviewId = Convert.ToInt32(GvReviews.DataKeys[e.RowIndex].Value);
            try
            {
                string query = "DELETE FROM ProductReviews WHERE ReviewId = @ReviewId";
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ReviewId", reviewId) };
                dc.ExecuteNonQuery(query, param);
                ShowAlert("Review deleted successfully.");
                LoadReviews();
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting review: " + ex.Message);
            }
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
