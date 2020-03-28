'use strict';

// noinspection JSUnresolvedFunction
const AWS = require('aws-sdk');

const dynamoDb = new AWS.DynamoDB.DocumentClient();

// noinspection JSUnresolvedVariable
module.exports.handle = (event, context, callback) => {

    // noinspection JSUnresolvedVariable
    const params = {
        TableName: process.env.DYNAMO_TABLE,
    };

    dynamoDb.scan(params, (error, result) => {
        // handle potential errors
        if (error) {
            console.error(error);
            callback(null, {
                statusCode: error.statusCode || 501,
                headers: {'Content-Type': 'text/plain'},
                body: 'Couldn\'t fetch the orders.',
            });
            return;
        }

        // create a response
        const response = {
            statusCode: 200,
            body: JSON.stringify(result.Items),
        };
        callback(null, response);
    });
};
