from avcloudapicommons.utils.constants import AggregatorsConstants
import logging
from fastapi import HTTPException, status

log = logging

def getAggregatorCondition(aggr: str):
    aggregates = [
        {
            AggregatorsConstants.FACET_OPERATOR : {
            }
        }
    ]
    try:
        if aggr is not None:
            values = aggr.split(AggregatorsConstants.AGGREGATE_SEARCH_DELIMITER)
            if len(values)!=0:
                for aggregateParameter in values:
                    aggregate = aggregateParameter.split(AggregatorsConstants.AGGREGATE_CONDITION_DELIMITER)
                    columnName = aggregate[AggregatorsConstants.INDEX_ZERO]
                    operatorType = aggregate[AggregatorsConstants.INDEX_ONE]
                    outputId = aggregate[AggregatorsConstants.INDEX_TWO]
                    if columnName==AggregatorsConstants.COLUMN_NAME_ID or operatorType==AggregatorsConstants.COUNT_OPERATOR:
                        aggregates[AggregatorsConstants.INDEX_ZERO][AggregatorsConstants.FACET_OPERATOR][outputId] = [{AggregatorsConstants.GROUP_OPERATOR:{AggregatorsConstants.COLUMN_ID:outputId,outputId:{AggregatorsConstants.SUM_OPERATOR:AggregatorsConstants.INDEX_ONE}}}]
                    else:
                        aggregates[AggregatorsConstants.INDEX_ZERO][AggregatorsConstants.FACET_OPERATOR][outputId] = [{AggregatorsConstants.GROUP_OPERATOR:{AggregatorsConstants.COLUMN_ID:outputId,outputId:{f"{AggregatorsConstants.MONGODB_AGGREGATE_PREFIX}{operatorType}":f"{AggregatorsConstants.MONGODB_AGGREGATE_PREFIX}{columnName}"}}}]
        return aggregates
    except Exception as error:
        log.error("Exception while create condition aggregate ", error)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=AggregatorsConstants.ERR_AGGREGATE_CONDITION,
        )