using System;
using System.Collections.Specialized;
using System.Web;

using Microsoft.IdentityModel.Clients.ActiveDirectory;

using PowerBiFullScreen.Properties;

namespace PowerBiFullScreen
{
    public partial class Default : System.Web.UI.Page
    {
        string baseUri = Properties.Settings.Default.PowerBiDataset;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Params.Get("code") != null && Session["AccessToken"] == null)
            {
                Session["AccessToken"] = GetAccessToken(
                    Request.Params.GetValues("code")[0],
                    Settings.Default.ClientId,
                    Settings.Default.ClientSecret,
                    Settings.Default.RedirectUri);
            }

            if (Session["AccessToken"] != null)
            {
                accessToken.Value = Session["AccessToken"].ToString();
                GetReport(0);
            }
            else
                GetAuthorizationCode();
        }

        protected void GetReport(int index)
        {
            NameValueCollection queryString;

            if (Request.Params.Get("state") != null)
                queryString = HttpUtility.ParseQueryString(
                    HttpUtility.UrlDecode(Request.Params.Get("state")));
            else
                queryString = Request.QueryString;

            var reportId = queryString["ReportID"];
            var workspaceId = queryString["WorkspaceID"];
            var reportSection = queryString["ReportSection"];

            hdEmbedUrl.Value = String.Format("https://app.powerbi.com/reportEmbed?reportId={0}&groupId={1}", reportId, workspaceId);
            hdReportId.Value = reportId;
            hdReportSection.Value = reportSection;
        }

        public void GetAuthorizationCode()
        {
            var @params = new NameValueCollection
            {
                //Azure AD will return an authorization code. 
                {"response_type", "code"},

                //Client ID is used by the application to identify themselves to the users that they are requesting permissions from. 
                //You get the client id when you register your Azure app.
                {"client_id", Settings.Default.ClientId},

                //Resource uri to the Power BI resource to be authorized
                //The resource uri is hard-coded for sample purposes
                {"resource", Properties.Settings.Default.PowerBiApi},

                //After app authenticates, Azure AD will redirect back to the web app. In this sample, Azure AD redirects back
                //to Default page (Default.aspx).
                { "redirect_uri", Settings.Default.RedirectUri},

                { "state", HttpUtility.UrlEncode(Request.QueryString.ToString()) }
            };

            //Create sign-in query string
            var queryString = HttpUtility.ParseQueryString(string.Empty);
            queryString.Add(@params);

            //Redirect to Azure AD to get an authorization code
            Response.Redirect(String.Format(Properties.Settings.Default.AadAuthorityUri + "?{0}", queryString));
        }

        public string GetAccessToken(string authorizationCode, string clientID, string clientSecret, string redirectUri)
        {
            // Get auth token from auth code       
            TokenCache TC = new TokenCache();

            string authority = Settings.Default.AadAuthorityUri;
            AuthenticationContext AC = new AuthenticationContext(authority, TC);
            ClientCredential cc = new ClientCredential(clientID, clientSecret);

            //Set token from authentication result
            return AC.AcquireTokenByAuthorizationCode(
                authorizationCode,
                new Uri(redirectUri), cc).AccessToken;
        }
    }
}