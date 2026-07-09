using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StockMangementSystem
{
    public partial class reports : System.Web.UI.Page
    {
        private DataCon dc = new DataCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default dates
                TxtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                TxtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                
                ToggleDateFilters();
                GenerateReport();
            }
        }

        protected void DdlReportType_SelectedIndexChanged(object sender, EventArgs e)
        {
            ToggleDateFilters();
            GenerateReport();
        }

        private void ToggleDateFilters()
        {
            string type = DdlReportType.SelectedValue;
            bool needsDate = (type == "Sales" || type == "Purchase" || type == "Profit");
            divStartDate.Visible = needsDate;
            divEndDate.Visible = needsDate;
        }

        protected void BtnGenerate_Click(object sender, EventArgs e)
        {
            GenerateReport();
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            DdlReportType.SelectedIndex = 0;
            TxtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
            TxtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            TxtSearch.Text = "";
            ToggleDateFilters();
            GenerateReport();
        }

        private void GenerateReport()
        {
            string type = DdlReportType.SelectedValue;
            LblReportHeader.Text = DdlReportType.SelectedItem.Text;
            SummaryPanel.Visible = false;

            try
            {
                DataTable dt = FetchReportData();
                GridReports.DataSource = dt;
                GridReports.DataBind();

                // Compute Profit Summary if applicable
                if (type == "Profit" && dt != null && dt.Rows.Count > 0)
                {
                    decimal totalRevenue = 0;
                    decimal totalCogs = 0;
                    decimal netProfit = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        totalRevenue += Convert.ToDecimal(row["Sales Revenue"]);
                        totalCogs += Convert.ToDecimal(row["Cost of Goods Sold"]);
                        netProfit += Convert.ToDecimal(row["Net Profit"]);
                    }

                    SummaryPanel.Visible = true;
                    SummaryTextLabel.Text = $"Total Revenue: <strong>${totalRevenue:N2}</strong> | Total COGS: <strong>${totalCogs:N2}</strong> | Net Profit: <strong class='{(netProfit >= 0 ? "text-success" : "text-danger")}'>${netProfit:N2}</strong>";
                }
            }
            catch (Exception ex)
            {
                LblReportHeader.Text = "Error Generating Report: " + ex.Message;
            }
        }

        private DataTable FetchReportData()
        {
            string type = DdlReportType.SelectedValue;
            string search = TxtSearch.Text.Trim();
            string query = "";
            List<SqlParameter> paramList = new List<SqlParameter>();

            DateTime start, end;
            DateTime.TryParse(TxtStartDate.Text, out start);
            DateTime.TryParse(TxtEndDate.Text, out end);
            end = end.AddDays(1).AddSeconds(-1); // Set to end of day 23:59:59

            if (type == "Product")
            {
                query = @"SELECT p.ProductCode as [Product Code], p.ProductName as [Item Name], c.CategoryName as [Category],
                                 p.PurchasePrice as [Cost ($)], p.SellingPrice as [Price ($)], p.Quantity as [In Stock],
                                 (p.Quantity * p.PurchasePrice) as [Inventory Cost ($)], (p.Quantity * p.SellingPrice) as [Potential Value ($)]
                          FROM Products p
                          INNER JOIN Categories c ON p.CategoryId = c.CategoryId
                          WHERE 1=1";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (p.ProductCode LIKE @Search OR p.ProductName LIKE @Search OR c.CategoryName LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }
                query += " ORDER BY p.ProductName ASC";
            }
            else if (type == "Sales")
            {
                query = @"SELECT s.InvoiceNumber as [Invoice], c.name as [Customer], p.ProductName as [Item],
                                 s.Quantity as [Qty], s.SellingPrice as [Price ($)], s.Discount as [Disc ($)],
                                 s.GST as [GST (%)], s.Total as [Total ($)], s.SaleDate as [Date]
                          FROM Sales s
                          INNER JOIN NewCustomer c ON s.CustomerId = c.Id
                          INNER JOIN Products p ON s.ProductCode = p.ProductCode
                          WHERE s.SaleDate BETWEEN @Start AND @End";

                paramList.Add(new SqlParameter("@Start", SqlDbType.DateTime) { Value = start });
                paramList.Add(new SqlParameter("@End", SqlDbType.DateTime) { Value = end });

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (s.InvoiceNumber LIKE @Search OR c.name LIKE @Search OR p.ProductName LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }
                query += " ORDER BY s.SaleDate DESC";
            }
            else if (type == "Purchase")
            {
                query = @"SELECT pur.PurchaseId as [Purchase ID], s.suppliername as [Supplier], p.ProductName as [Item],
                                 pur.Quantity as [Qty], pur.PurchasePrice as [Cost ($)], (pur.Quantity * pur.PurchasePrice) as [Total Cost ($)],
                                 pur.PurchaseDate as [Date]
                          FROM Purchases pur
                          INNER JOIN NewSupplier s ON pur.SupplierId = s.supplierid
                          INNER JOIN Products p ON pur.ProductCode = p.ProductCode
                          WHERE pur.PurchaseDate BETWEEN @Start AND @End";

                paramList.Add(new SqlParameter("@Start", SqlDbType.DateTime) { Value = start });
                paramList.Add(new SqlParameter("@End", SqlDbType.DateTime) { Value = end });

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (s.suppliername LIKE @Search OR p.ProductName LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }
                query += " ORDER BY pur.PurchaseDate DESC";
            }
            else if (type == "Supplier")
            {
                query = @"SELECT supplierid as [ID], suppliername as [Supplier Name], companyname as [Company],
                                 contactperson as [Contact Person], phonenumber as [Phone], email as [Email],
                                 address as [Address], city as [City], gstnumber as [GSTIN], supplierstatus as [Status]
                          FROM NewSupplier
                          WHERE 1=1";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (suppliername LIKE @Search OR companyname LIKE @Search OR city LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }
                query += " ORDER BY suppliername ASC";
            }
            else if (type == "Customer")
            {
                query = @"SELECT Id as [ID], name as [Customer Name], number as [Mobile], email as [Email],
                                 address as [Address], city as [City], gstnumber as [GSTIN], status as [Status]
                          FROM NewCustomer
                          WHERE 1=1";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (name LIKE @Search OR city LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }
                query += " ORDER BY name ASC";
            }
            else if (type == "Profit")
            {
                query = @"SELECT s.InvoiceNumber as [Invoice], p.ProductName as [Item Name], s.Quantity as [Quantity Sold],
                                 s.SellingPrice as [Unit Selling Price], p.PurchasePrice as [Unit Cost Price],
                                 (s.Quantity * s.SellingPrice) as [Sales Revenue], (s.Quantity * p.PurchasePrice) as [Cost of Goods Sold],
                                 ((s.Quantity * s.SellingPrice) - (s.Quantity * p.PurchasePrice) - s.Discount) as [Net Profit],
                                 s.SaleDate as [Date]
                          FROM Sales s
                          INNER JOIN Products p ON s.ProductCode = p.ProductCode
                          WHERE s.SaleDate BETWEEN @Start AND @End";

                paramList.Add(new SqlParameter("@Start", SqlDbType.DateTime) { Value = start });
                paramList.Add(new SqlParameter("@End", SqlDbType.DateTime) { Value = end });

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (s.InvoiceNumber LIKE @Search OR p.ProductName LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", SqlDbType.VarChar) { Value = "%" + search + "%" });
                }
                query += " ORDER BY s.SaleDate DESC";
            }

            DataSet ds = dc.GetDataSet(query, paramList.ToArray());
            return ds.Tables[0];
        }

        protected void GridReports_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridReports.PageIndex = e.NewPageIndex;
            GenerateReport();
        }

        protected void BtnExportExcel_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = FetchReportData();
                if (dt != null && dt.Rows.Count > 0)
                {
                    ExportToCSV(dt, $"{DdlReportType.SelectedValue}_Report_{DateTime.Now:yyyyMMdd}");
                }
            }
            catch (Exception ex)
            {
                LblReportHeader.Text = "Export Error: " + ex.Message;
            }
        }

        private void ExportToCSV(DataTable dt, string filename)
        {
            StringBuilder sb = new StringBuilder();

            // Column Headers
            string[] columnNames = new string[dt.Columns.Count];
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                columnNames[i] = dt.Columns[i].ColumnName;
            }
            sb.AppendLine(string.Join(",", columnNames));

            // Data Rows
            foreach (DataRow row in dt.Rows)
            {
                string[] fields = new string[dt.Columns.Count];
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    string cellValue = row[i].ToString();
                    // Escape commas and double quotes
                    if (cellValue.Contains(",") || cellValue.Contains("\""))
                    {
                        cellValue = "\"" + cellValue.Replace("\"", "\"\"") + "\"";
                    }
                    fields[i] = cellValue;
                }
                sb.AppendLine(string.Join(",", fields));
            }

            // Flush response
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "text/csv";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + filename + ".csv");
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.Write(sb.ToString());
            HttpContext.Current.Response.End();
        }
    }
}
