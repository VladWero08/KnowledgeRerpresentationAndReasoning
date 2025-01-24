import os
import socket

class API:
    dogs = ["German Shepherd", "Rottweiler", "Beagle"]

    def __init__(self):
        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        self.html = None
        html_path = os.path.join(self.base_dir, "src", "index.html")

        with open(html_path, "r") as f:
            self.html = f.read()

    def submit_form(self, data: dict):
        """
        Handle form submission from the frontend.
        This method will be called by JavaScript when the form is submitted.
        """
        predicates = self.compute_predicates(data)
        clause = self.compute_clause(predicates)

        prolog = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            # connect to the prolog server
            prolog.connect(("localhost", 5000))
            # send the clause that needs to be interogated
            prolog.sendall(clause.encode("utf-8"))
            # wait for the response from the server
            response = prolog.recv(1024).decode("utf-8")
            response = response[1:len(response)-2].split(",")
            response = {self.dogs[i]: response[i] for i in range(len(response))}

            return response
        except Exception as e:
            print("Error while sending the clause to the Prolog server:", e)
        finally:
            # close the connection to the server
            prolog.close()

    def compute_predicates(self, data: dict) -> list:
        """
        Given a dictionary with the answert to the dog
        related questions of the user, extract the positive
        predicates from it.

        Return
        ------
        predicates: list
            A list of string that represent the predicates that target the given player.
        """
        predicates = []

        if int(data["weight"]) > 20:
            predicates.append("big")
        else:
            predicates.append("small")
        
        if data["intelligent"] == "yes":
            predicates.append("intelligent")
        if data["playful"] == "yes":
            predicates.append("playful")
        if data["trainable"] == "yes":
            predicates.append("trainable")

        return predicates
    
    def compute_clause(
        self,
        predicates: list[str]
    ) -> str:
        """
        Given a list of predicates, build the clause in a format
        that will be understand by the Prolog program.
        """
        clauses = []

        # add all N - 1 predicates as clauses
        for predicate in predicates:
            clauses.append(f"'(',{predicate},')'")

        # add the last predicate
        clause = f"[{',and,'.join(clauses)}]\n"

        return clause

