docker run -d --name=docusaurus \
	-p 80:80 \
	-v ./docusaurus:/docusaurus \
	-e TARGET_UID=1000 \
	-e TARGET_GID=1000 \
	-e WEBSITE_NAME="awesometic-docs" \
	-e MAXLISTENRTS=20 \
	-e TEMPLATE=classic \
	jackywn/docusaurus
