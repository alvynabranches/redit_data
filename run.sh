export DATASET="data"
bq mk --dataset ${DATASET?}




export TABLE=reddit

# For all data up to 2019.
export TABLE_REGEX="^201[5678]_[01][0-9]$"

export QUERY="SELECT * \
  FROM TABLE_QUERY(\
  [fh-bigquery:reddit_comments], \
  \"REGEXP_MATCH(table_id, '${TABLE_REGEX?}')\" )"

# Run the query.
echo "${QUERY?}" | bq query \
  --n 0 \
  --batch --allow_large_results \
  --destination_table ${DATASET?}.${TABLE?} \
  --use_legacy_sql=true





export PROJECT="summ-270612"
export BUCKET="reddit_data_fine_tuning"

export DATADIR="gs://${BUCKET?}/reddit/$(date +"%Y%m%d")"

# The below uses values of $DATASET and $TABLE set
# in the previous section.

python reddit/create_data.py \
  --output_dir ${DATADIR?} \
  --reddit_table ${PROJECT?}:${DATASET?}.${TABLE?} \
  --runner DataflowRunner \
  --temp_location ${DATADIR?}/temp \
  --staging_location ${DATADIR?}/staging \
  --project ${PROJECT?} \
  --dataset_format TF