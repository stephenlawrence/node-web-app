let appRouter = function (app) {

    app.get("/time", function (req, res) {
        var timeStamp = Math.floor(Date.now() / 1000);
        var requestData = {
            name: 'time5',
            value: timeStamp
        };

        res.send(requestData);
    });
};

module.exports = appRouter;
