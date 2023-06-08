# Great Expectations

Great Expectations is a tool for validating, documenting and profiling data to maintain quality.

# Installation
``` shell
pip install great_expectations
```

# Quick Start
``` python
import great_expectations as gx

# create DataContext object
context = gx.get_context()

# connect to data
validator = context.sources.pandas_default.read_csv(
    "https://raw.githubusercontent.com/great-expectations/gx_tutorials/main/data/yellow_tripdata_sample_2019-01.csv"
)

# create expectations
validator.expect_column_values_to_not_be_null("pickup_datetime")
validator.expect_column_values_to_be_between("passenger_count", auto=True)

# define a checkpoint
checkpoint = gx.checkpoint.SimpleCheckpoint(
    name="my_quickstart_checkpoint",
    data_context=context,
    validator=validator,
)

# return the validation results
checkpoint_result = checkpoint.run()

# view the html representation of the validation resultss
validation_result_identifier = checkpoint_result.list_validation_result_identifiers()[0]
context.open_data_docs(resource_identifier=validation_result_identifier)
```

# Key Features

