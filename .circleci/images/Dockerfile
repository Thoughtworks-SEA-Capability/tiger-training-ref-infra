FROM docker.mirror.hashicorp.services/hashicorp/terraform:latest
RUN apk add --no-cache aws-cli
RUN apk add --no-cache curl
RUN apk add --no-cache bash
COPY install_tfsec_linux.sh .
RUN chmod +x ./install_tfsec_linux.sh
RUN ./install_tfsec_linux.sh
