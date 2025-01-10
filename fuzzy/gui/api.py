import os
import socket

class API:
    def __init__(self):
        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        self.html = None
        html_path = os.path.join(self.base_dir, "src", "index.html")

        with open(html_path, "r") as f:
            self.html = f.read()

    def stop(self):
        """
        Stops the prolog server.
        """
        __stop = "STOP"
        __stop = __stop.encode("utf-8")
        prolog = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            # connect to the prolog server
            prolog.connect(("localhost", 5000))
            # send the premises 
            prolog.sendall(__stop)
            # wait for the response from the server
            response = prolog.recv(1024).decode("utf-8")
        except Exception as e:
            print("Error while sending the premises to the Prolog server:", e)
        finally:
            # close the connection to the server
            prolog.close()

        return response
        

    def submit_form(self, data: dict):
        """
        Handle form submission from the frontend.
        This method will be called by JavaScript when the form is submitted.
        """
        premises = self.compute_premises(age=data["age"], mileage=data["mileage"], consumption=data["consumption"])
        premises = premises.encode("utf-8")

        prolog = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            # connect to the prolog server
            prolog.connect(("localhost", 5000))
            # send the premises 
            prolog.sendall(premises)
            # wait for the response from the server
            response = prolog.recv(1024).decode("utf-8")
        except Exception as e:
            print("Error while sending the premises to the Prolog server:", e)
        finally:
            # close the connection to the server
            prolog.close()

        return response
    
    def compute_premises(
        self, 
        age: str,
        mileage: str, 
        consumption: str
    ) -> str:
        """
        Return
        ------
        premises: str
            A string that contains all the premises predicates
            and their values given as parameters.

            `[age/{age_value},mileage/{mileage_value},consumption/{consumption_value}]`
        """
        return f"[age/{age},mileage/{mileage},consumption/{consumption}]\n"