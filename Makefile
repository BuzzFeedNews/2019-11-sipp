.PHONY: analysis download wave1 wave2 wave1_public wave1_replicate wave4_public wave4_replicate

download: wave1 wave4

analysis:
	cd notebooks && nbexec load_public.ipynb filter_supports.ipynb load_replicates.ipynb analysis.ipynb

wave1: wave1_public wave1_replicate 

wave4: wave4_public wave4_replicate 

wave1_public:
	mkdir -p data
	curl -o data/pu2014w1_dta.zip https://thedataweb.rm.census.gov/pub/sipp/2014/pu2014w1_dta.zip
	unzip -o data/pu2014w1_dta.zip -d data/

wave4_public:
	mkdir -p data
	curl -o data/pu2014w4_dta.zip https://www2.census.gov/programs-surveys/sipp/data/datasets/2014/w4/pu2014w4_dta.zip
	unzip -o data/pu2014w4_dta.zip -d data/

wave1_replicate:
	curl -o data/rw14w1_dta.zip https://www2.census.gov/programs-surveys/sipp/data/datasets/2014/w1/rw14w1_dta.zip
	unzip -o data/rw14w1_dta.zip -d data/

wave4_replicate:
	curl -o data/rw14w4_dta.zip https://www2.census.gov/programs-surveys/sipp/data/datasets/2014/w4/rw14w4_dta.zip
	unzip -o data/rw14w4_dta.zip -d data/
