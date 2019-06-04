generate-code:	## Uses sourcery to generate swift code
	sourcery --sources Postify/ --templates SourceryTemplates/ --output Postify/SourceryGenerated/
