#our base image
FROM julia:1.5.3

# install julia dependencies
COPY Deps.jl  /usr/src/app/ 
RUN julia /usr/src/app/Deps.jl
COPY *.jl /ICI_simulateur/src/
COPY 
#RUN julia --project=ICI_simulateur ICI_simulateur/src/create_sysimage.jl

# copy files required for the app to run
#COPY *.jl /usr/src/app/
#ADD Data /usr/src/app/
#ADD Res /usr/src/app/
# run the application
#CMD ["julia", "/usr/src/app/Simulateur_by_Module.jl"]
CMD ["julia","--project=ICI_simulateur"] 