# Set base image
FROM ohdsi/broadsea-shiny:1.0.0

# install additional required OS dependencies
RUN apt-get update && \
    apt-get install -y python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install additional required Python packages
RUN pip install faicons

# install additional required R packages
RUN R -e "install.packages('renv')"
RUN R -e "library(renv)"
RUN R -e "renv::restore()"


# Set an argument for the app name
ARG APP_NAME

# Set arguments for the GitHub branch and commit id abbreviation
ARG GIT_BRANCH=unknown
ARG GIT_COMMIT_ID_ABBREV=unknown

# Set workdir and copy app files
WORKDIR /srv/shiny-server/${APP_NAME}
COPY . .

# Expose default Shiny app port
EXPOSE 3838

# Run the Shiny app
CMD R -e "shiny::runApp('/srv/shiny-server/${APP_NAME}', host = '0.0.0.0', port = 3838)"
