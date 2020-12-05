# Instructions

## Prerequisites

1.) You will need to have docker installed. We chose this way to try out the code

## Run

1.) Open terminal at day5 directory.

2.) Run ``` sudo docker run -it -v $(pwd):/tmp/day5 haskell bash```, to create your environment. It opens a new shell inside the docker image.

3.) Run ``` ghc -o task task.hs ```

4.) Run ``` ./task ```

5.) Expected result should be:

```
Task1 solution: 996
Task2 solution: 671
```

