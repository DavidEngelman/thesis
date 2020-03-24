
##################
#  SAVE RESULTS  #
##################
import json
import numpy


def convertToJsonSerializable(data):
    if type(data) == numpy.ndarray:
        data = data.tolist()
    elif type(data) == tuple:
        data = tuple([convertToJsonSerializable(x) for x in data])
    elif type(data) == list:
        data = [convertToJsonSerializable(x) for x in data]
    elif type(data) == dict:
        data = dict([(convertToJsonSerializable(k), convertToJsonSerializable(v)) for k,v in data.items()])
    return data


def saveToFile(filename, data):
    with open(filename, 'w') as f:
        data = convertToJsonSerializable(data)
        json.dump(data, f)


def readFromFile(filename):
    with open(filename) as f:
        return json.load(f)


def remap_keys(mapping):
    return [{'key': k, 'value': v} for k, v in mapping.items()]


def demap_keys(mapping):
    return {tuple(element['key']): element['value'] for element in mapping}


def saveComplexJson(filename, data):
    saveToFile(filename, remap_keys(data))


def readComplexJson(filename):
    return demap_keys(readFromFile(filename))


def removeEmptyListValues(d):
    return {k: v for k, v in d.items() if len(v) > 0}


##################
#    PARALLEL    #
##################

from multiprocessing import Pool



def parallelize(addAsyncJobs, numProcesses=4, jobFinishedCallback=None):
    jobs = {}
    results = {}

    pool = Pool(processes=numProcesses)
    addAsyncJobs(jobs, pool)

    # Put job results in results
    for key, job in jobs.items():
        results[key] = job.get()

        if jobFinishedCallback:
            jobFinishedCallback(key)

    pool.close()
    pool.join()

    return results