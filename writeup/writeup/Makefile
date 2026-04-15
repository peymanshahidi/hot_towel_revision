
project_name = hot_towel
pretty_name = ese

ts := $(shell /bin/date "+%Y-%m-%d---%H-%M-%S")

params =
# DONE 
params += params_exp_details.tex
params_exp_details.tex: ../analysis/params_exp_details.R
	cd ../analysis && ./params_exp_details.R
# DONE 
params += params_chi_square.tex
params_chi_square.tex: ../analysis/params_chi_square.R
	cd ../analysis && ./params_chi_square.R 

# DONE 
params += params_choices_by_cat.tex
params_choices_by_cat.tex: ../analysis/choices_by_cat.R
	cd ../analysis && ./choices_by_cat.R 

# DONE 
params += params_signal_effects_wage_bidding.tex
params_signal_effects_wage_bidding.tex: ../analysis/signal_effects_wage_bidding.R
	cd ../analysis && ./signal_effects_wage_bidding.R 

# DONE 
params += params_signal_effects_experience.tex
params_signal_effects_experience.tex: ../analysis/signal_effects_experience.R
	cd ../analysis && ./signal_effects_experience.R 

# DONE 
params += params_bidding_effect.tex
params_bidding_effect.tex: ../analysis/bidding_effect.R
	cd ../analysis && ./bidding_effect.R

# DONE 
params += params_app_counts.tex
params_app_counts.tex: ../analysis/app_counts.R
	cd ../analysis && ./app_counts.R 

# DONE 
params += params_worker_targeted_apps.tex
params_worker_targeted_apps.tex: ../analysis/worker_targeted_apps.R
	cd ../analysis && ./worker_targeted_apps.R

# DONE 
params += params_condition_on_pool_size.tex
params_condition_on_pool_size.tex: ../analysis/condition_on_pool_size.R
	cd ../analysis && ./condition_on_pool_size.R

# DONE 
params += params_trt_effects.tex
params_trt_effects.tex: ../analysis/trt_effects.R
	cd ../analysis && ./trt_effects.R


../analysis/HotTowelR_installed.txt: ../analysis/HotTowelR/R/*R ../analysis/HotTowelR/DESCRIPTION
	cd ../analysis && ./install_HotTowelR.R

../computed_objects/condition_on_pool_size.rds: ../analysis/co_condition_on_pool_size.R
	cd ../analysis && ./co_condition_on_pool_size.R

tables = 

tables += ./tables/welfare.tex
tables/welfare.tex: ../analysis/table_welfare.R
	cd ../analysis && ./table_welfare.R

# DONE 
tables += ./tables/balance_big.tex
tables/balance_big.tex: ../analysis/balance_big.R
	cd ../analysis && ./balance_big.R

tables += ./tables/balance_big_filled.tex
tables/balance_big_filled.tex: ../analysis/balance_big_filled.R
	cd ../analysis && ./balance_big_filled.R

# DONE 
# tables += ./tables/worker_targeted_apps.tex
# ./tables/worker_targeted_apps.tex: ../analysis/worker_targeted_apps.R
# 	cd ../analysis && ./worker_targeted_apps.R

# DONE
tables += ./tables/bidding_effect.tex
tables/bidding_effect.tex: ../analysis/bidding_effect.R
	cd ../analysis && ./bidding_effect.R

# DONE 
tables += ./tables/app_counts.tex
./tables/app_counts.tex: ../analysis/app_counts.R
	cd ../analysis && ./app_counts.R

# DONE 
tables += ./tables/condition_on_pool_size.tex
./tables/condition_on_pool_size.tex: ../computed_objects/condition_on_pool_size.rds ../analysis/condition_on_pool_size.R
	cd ../analysis && ./condition_on_pool_size.R

# DONE 
tables += ./tables/compensating_differential_argument.tex
./tables/compensating_differential_argument.tex: ../analysis/compensating_differential_argument.R ../computed_objects/compensating_differential_argument.rds
	cd ../analysis && ./compensating_differential_argument.R

# DONE 
tables += ./tables/employer_choice_fe.tex
 ./tables/employer_choice_fe.tex: ../analysis/employer_choice_fe.R
	cd ../analysis && ./employer_choice_fe.R


# tables += ./tables/knowledge_and_choice_past_exper.tex
# ./tables/knowledge_and_choice_past_exper.tex: ../analysis/knowledge_and_choice_past_exper.R
# 	cd ../analysis && ./knowledge_and_choice_past_exper.R


# # tables += ./tables/profile_rate_percentiles.tex
# # ./tables/profile_rate_percentiles.tex: ../analysis/profile_rate_percentiles.R
# # 	cd ../analysis && ./profile_rate_percentiles.R

# # tables += ./tables/past_earnings_percentiles.tex
# # ./tables/past_earnings_percentiles.tex: ../analysis/past_earnings_percentiles.R
# # 	cd ../analysis && ./past_earnings_percentiles.R

# tables += ./tables/ats_message.tex
# ./tables/ats_message.tex: ../analysis/ats_message.R
# 	cd ../analysis && ./ats_message.R


# tables += ./tables/feedback.tex
#  ./tables/feedback.tex: ../analysis/feedback.R
# 	cd ../analysis && ./feedback.R

# tables += ./tables/fills.tex
#  ./tables/fills.tex: ../analysis/fills.R
# 	cd ../analysis && ./fills.R

# tables += ./tables/hired_rate.tex
#  ./tables/hired_rate.tex: ../analysis/hired_rate.R
# 	cd ../analysis && ./hired_rate.R

# tables += ./tables/hours.tex
#  ./tables/hours.tex: ../analysis/hours.R
# 	cd ../analysis && ./hours.R

# tables += ./tables/interviews.tex
#  ./tables/interviews.tex: ../analysis/interviews.R
# 	cd ../analysis && ./interviews.R

# tables += ./tables/invites.tex
#  ./tables/invites.tex: ../analysis/invites.R
# 	cd ../analysis && ./invites.R

# tables += ./tables/job_complexity.tex
#  ./tables/job_complexity.tex: ../analysis/job_complexity.R
# 	cd ../analysis && ./job_complexity.R

# tables += ./tables/job_duration.tex
#  ./tables/job_duration.tex: ../analysis/job_duration.R
# 	cd ../analysis && ./job_duration.R

# # tables += ./tables/markups.tex
# #  ./tables/markups.tex: ../analysis/markups.R
# # 	cd ../analysis && ./markups.R


# tables += ./tables/spend.tex
#  ./tables/spend.tex: ../analysis/spend.R
# 	cd ../analysis && ./spend.R


# tables += ./tables/success.tex
#  ./tables/success.tex: ../analysis/success.R
# 	cd ../analysis && ./success.R


# tables += ./tables/viewing.tex
#  ./tables/viewing.tex: ../analysis/viewing.R
# 	cd ../analysis && ./viewing.R


# tables += ./tables/wage_bid_percentiles.tex
#  ./tables/wage_bid_percentiles.tex: ../analysis/wage_bid_percentiles.R
# 	cd ../analysis && ./wage_bid_percentiles.R


plots = 

plots += plots/compare_outcomes_controlled.pdf
plots/compare_outcomes_controlled.pdf: ../analysis/plot_compare_outcomes_controlled.R 
	cd ../analysis && ./plot_compare_outcomes_controlled.R

plots += plots/trt_effects_robust.pdf
plots/trt_effects_robust.pdf: ../analysis/trt_effects_robust.R ../computed_objects/trt_effects_robust.rds
	cd ../analysis && ./trt_effects_robust.R

plots += plots/bidding_effect.pdf
plots/bidding_effect.pdf: ../analysis/plot_bidding_effect.R
	cd ../analysis && ./plot_bidding_effect.R

plots += plots/app_counts.pdf
plots/app_counts.pdf: ../analysis/plot_app_counts.R
	cd ../analysis && ./plot_app_counts.R

plots += plots/experience_sorting_by_cat.pdf
plots/experience_sorting_by_cat.pdf: ../analysis/plot_experience_sorting_by_cat.R
	cd ../analysis && ./plot_experience_sorting_by_cat.R

plots += plots/choices_by_cat.pdf
plots/choices_by_cat.pdf: ../analysis/choices_by_cat.R
	cd ../analysis && ./choices_by_cat.R

plots += plots/signal_effects_experience.pdf
plots/signal_effects_experience.pdf: ../analysis/signal_effects_experience.R ../computed_objects/signal_effects.rds
	cd ../analysis && ./signal_effects_experience.R


plots += plots/signal_effects_wage_bidding.pdf
plots/signal_effects_wage_bidding.pdf: ../analysis/signal_effects_wage_bidding.R ../computed_objects/signal_effects.rds
	cd ../analysis && ./signal_effects_wage_bidding.R

plots += plots/trt_effects.pdf
plots/trt_effects.pdf: ../analysis/trt_effects.R ../computed_objects/trt_effects.rds
	cd ../analysis && ./trt_effects.R


plots += plots/trt_effects_feedback.pdf
plots/trt_effects_feedback.pdf: ../analysis/trt_effects_feedback.R ../computed_objects/trt_effects.rds
	cd ../analysis && ./trt_effects_feedback.R


../computed_objects/compensating_differential_argument.rds: ../analysis/compensating_differential_argument.R
	cd ../analysis && ./co_compensating_differential_argument.R

../computed_objects/signal_effects.rds: ../analysis/co_signal_effects.R
	cd ../analysis && ./co_signal_effects.R 


../computed_objects/compare_wb_to_pr_hired.rds: ../analysis/co_compare_wb_to_pr_hired.R
	cd ../analysis && ./co_compare_wb_to_pr_hired.R

../computed_objects/compare_wb_to_pr.rds: ../analysis/co_compare_wb_to_pr.R
	cd ../analysis && ./co_compare_wb_to_pr.R


../computed_objects/compare_experience_hired.rds: ../analysis/co_compare_experience_hired.R
	cd ../analysis && ./co_compare_experience_hired.R

../computed_objects/compare_experience.rds: ../analysis/co_compare_experience.R
	cd ../analysis && ./co_compare_experience.R


../computed_objects/trt_effects.rds: ../analysis/co_trt_effects.R
	cd ../analysis && ./co_trt_effects.R 

../computed_objects/trt_effects_robust.rds: ../analysis/co_trt_effects.R
	cd ../analysis && ./co_trt_effects.R 

plots += plots/tiers_over_time.pdf
plots/tiers_over_time.pdf: ../analysis/tiers_over_time.R
	cd ../analysis && ./tiers_over_time.R

plots += plots/compare_experience.pdf
plots/compare_experience.pdf: ../analysis/compare_experience.R ../computed_objects/compare_experience.rds ../computed_objects/compare_experience_hired.rds
	cd ../analysis && ./compare_experience.R 

plots += plots/compare_wb_to_pr.pdf
plots/compare_wb_to_pr.pdf: ../analysis/compare_wb_to_pr.R ../computed_objects/compare_wb_to_pr.rds ../computed_objects/compare_wb_to_pr_hired.rds
	cd ../analysis && ./compare_wb_to_pr.R

# plots += plots/compare_wb_to_pr_hired.pdf
# plots/compare_wb_to_pr_hired.pdf: ../analysis/compare_wb_to_pr_hired.R
# 	cd ../analysis && ./compare_wb_to_pr_hired.R

# plots += plots/signal_effects.pdf
# plots/signal_effects.pdf: ../analysis/signal_effects.R ../computed_objects/signal_effects.rds
# 	cd ../analysis && ./signal_effects.R

# plots += plots/multiple_outcomes.pdf
# plots/multiple_outcomes.pdf: ../analysis/multiple_outcomes.R
# 	cd ../analysis && ./multiple_outcomes.R

# plots += ./plots/signal_effects_by_cat_and_tier.pdf
# ./plots/signal_effects_by_cat_and_tier.pdf: ../analysis/signal_effects_by_cat_and_tier.R
# 	cd ../analysis && ./signal_effects_by_cat_and_tier.R 

# plots += plots/pref_by_level2.pdf
# plots/pref_by_level2.pdf: ../analysis/pref_by_level2.R
# 	cd ../analysis && ./pref_by_level2.R

$(project_name).pdf: $(project_name).bib $(project_name).tex ../analysis/HotTowelR_installed.txt $(tables) $(plots) $(params)
	pdflatex -interaction=batchmode $(project_name)
	bibtex $(project_name)
	pdflatex -interaction=batchmode $(project_name)
	pdflatex -interaction=batchmode $(project_name) 

# gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=tmp.pdf $(project_name).pdf

toread: $(project_name).pdf
	scp $(project_name).pdf bandit-local.local:/home/john/Dropbox/toread/$(project_name)_$(ts).pdf 

toread_bandit: $(project_name).pdf
	scp $(project_name).pdf bandit:/home/ubuntu/Dropbox/toread/$(project_name)_$(ts).pdf 

../backups/$(project_name)_$(ts).tar.gz:
	tar --exclude='../backups' --exclude='../.git' -zcvf ../backups/$(project_name)_$(ts).tar.gz ../

backup: ../backups/$(project_name)_$(ts).tar.gz
	echo "Making backup"

backup_s3: ../backups/$(project_name)_$(ts).tar.gz
	aws s3 cp ../backups/$(project_name)_$(ts).tar.gz s3://john_horton_backups/

backup_glacier: ../backups/$(project_name)_$(ts).tar.gz
	aws glacier upload-archive --account-id - --vault-name backups --archive-description $(project_name)_$(ts).tar.gz --body  ../backups/$(project_name)_$(ts).tar.gz >> ../backups/glacier_history.txt

snapshot:
	@echo Timestamp is $(ts)
	cp $(project_name).pdf ../snapshots/$(project_name)_$(ts).pdf

$(pretty_name).pdf: $(project_name).pdf
	cp $(project_name).pdf $(pretty_name).pdf

website: $(project_name).pdf
	printf 'cd papers\nput $<\n' \ | sftp -oPort=2222 -oCiphers=aes256-ctr johnjhorton@104.198.96.220

website_original: $(project_name).pdf
	printf 'cd papers\nput $<\n' \ | sftp -oPort=2222 -oCiphers=aes256-ctr johnjhorton@104.198.96.220

clean:
	rm *.aux *.log *.out *.bbl *.blg *.dvi *.aux *.fff *.lof *.out 

purge:
	cd plots && mv *pdf *png *svg unused/
	cd tables && mv *tex unused/
	cd ../computed_objects && mv *rds unused/
