: ' The --rid-brute flag is designed to identify domain user accounts and can be particularly effective when NULL Authentication is enabled, albeit with some query limitations. It works by enumerating users and other domain objects through their unique Relative Identifiers (RID).

#Each account on a Windows domain is assigned a distinctive RID. The --rid-brute flag leverages this by attempting to determine user accounts via RID brute-forcing.


The operation of the --rid-brute flag involves several steps:
    It initiates the process with well-known and predictable RIDs, such as 500, which is commonly associated with the default administrator account.

    It continues to brute-force a specified range of RIDs.

    The flag then sends queries to the domain controller, translating each RID into its corresponding username.

By default, the brute-forcing is conducted on RIDs up to 4000. This behavior can be customized by specifying a different maximum RID using the syntax --rid-brute [MAX_RID].

An example of this is:

    crackmapexec smb $TargetIP -u '' -p '' --rid-brute 8000 > ridOutput.txt

The resulting output is formatted like this:

    [{'rid': 498, 'domain': '%DOMAIN%', 'username': 'Enterprise Read-only Domain Controllers', 'sidtype': 'SidTypeGroup'}, {'rid': 500, 'domain': 'OrgDomainName', 'username': 'Administrator', 'sidtype': 'SidTypeUser'},....]

If you want to pass the results to try and find ASREPRoastable accounts, say, to a command like the following, the file needs to be cleaned so only user objects are present. As you can see in the example output above, there are different SidTypes included from the brute-forcing. You can clean the output with the bash script one liner at the end of this file.

Example command to find ASREPRoastable accounts:

crackmapexec ldap $HOSTIP -u users.txt -p '' --asreproast asreproast.out --kdcHost OrgDomainName
'

grep -oP "'username': '\K[^']+(?=', 'sidtype': 'SidTypeUser')" ridOutput.txt > usernames.txt