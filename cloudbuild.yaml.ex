steps:

  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    id: 'Check Saleor Core'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
       
            gcloud builds submit --config saleor-core/saleorcore-build.yaml .
      
    
  # Check changes in the saleor-dashboard directory
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
          gcloud builds submit --config saleor-dashboard/dashboard-build.yaml .
        

  # Check changes in the saleor-storefront directory
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
          gcloud builds submit --config saleor-storefront/storefront-build.yaml  .
